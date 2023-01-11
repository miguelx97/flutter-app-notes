import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:taskii/models/note.dart';
import 'package:taskii/models/note_status.enum.dart';
import 'package:taskii/services/notification.services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../global/ui.dart';
import '../models/category.dart';
import '../models/note_filters.dart';
import '../services/auth.service.dart';

class NotesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<Note> _notes = [];
  Note? _selectedNote = Note();
  final CollectionReference firestoreCollection =
      FirebaseFirestore.instance.collection("notes");

  final NoteFilters _filters = NoteFilters();
  int? _currentStatus;
  bool loadedNotesFromFb = false;

  NotesProvider() {
    // _notes = Mockups.notes;
    load(NoteStatus.pending);
    removeOldDeletedNotes();
  }

  getAll() {
    final String? selectedCategoryId = _filters.category?.cid;
    final String? search = _filters.search;
    List<Note> filteredNotesList = List.from(_notes);

    if (selectedCategoryId != null) {
      filteredNotesList = filteredNotesList
          .where((element) => element.categoryId == selectedCategoryId)
          .toList();
    }
    if (search != null && search.isNotEmpty) {
      final searchRegex = RegExp(search, caseSensitive: false);
      filteredNotesList = filteredNotesList
          .where((element) => (element.title.contains(searchRegex) ||
              (element.description ?? '').contains(searchRegex)))
          .toList();
    }

    return filteredNotesList;
  }

  Future<void> selectedNoteById(String nid) async {
    final DocumentSnapshot<Object?> doc =
        await firestoreCollection.doc(nid).get();

    final Map<String, dynamic> noteMap = doc.data()! as Map<String, dynamic>;
    final Note note = Note.fromMapWithId(noteMap, doc.id);
    print('Get note from firebase: ${note.title}');
    selectedNote = note;
  }

  load(int status) async {
    _notes.clear();
    notifyListeners();
    final String? uid = AuthService().currentUser?.uid;
    // EasyLoading.show(status: 'Cargando tus notas...');
    try {
      final QuerySnapshot notesSnapshot = await firestoreCollection
          .where("uid", isEqualTo: uid)
          .where("status", isEqualTo: status)
          .orderBy("isFavourite", descending: true)
          .orderBy("position", descending: true)
          .get();
      for (var doc in notesSnapshot.docs) {
        final Map<String, dynamic> noteMap =
            doc.data()! as Map<String, dynamic>;
        final Note note = Note.fromMapWithId(noteMap, doc.id);
        _notes.add(note);
      }
      loadedNotesFromFb = true;
    } on Exception catch (ex) {
      EasyLoading.showError('Error al cargar las notas');
    }
    print('Get all notes from firebase: ${_notes.length}');
    // EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> saveAndUpdate(Note note) async {
    bool isNew = note.nid == null || note.nid!.isEmpty;
    EasyLoading.show(status: '${isNew ? 'Guardando' : 'Actualizando'} nota...');
    try {
      if (note.title.isEmpty) throw Exception('Debes poner un título');
      note.title = note.title.trim();
      if (note.description != null) note.description = note.description!.trim();
      if (isNew) {
        await insert(note);
      } else {
        await update(note);
      }
    } on Exception catch (ex) {
      showError(ex,
          defaultMessage:
              'Error al ${isNew ? 'Guardar' : 'Actualizar'} la nota');
      rethrow;
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> insert(Note note) async {
    note = Note.clone(note);
    note.uid = AuthService().currentUser?.uid;
    note.position = topPosition();
    note.status = NoteStatus.pending;
    note.createionDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    DocumentReference doc = await firestoreCollection.add(note.toMap());
    note.nid = doc.id;
    if (currentStauts == NoteStatus.pending) {
      _notes.add(note);
      sortNotes();
    } else {
      currentStauts = NoteStatus.pending;
    }
    await setNoteNotificacion(note);
  }

  topPosition() => DateTime.now().millisecondsSinceEpoch.toDouble();

  // delete(String noteId) async {
  //   await firestoreCollection.doc(noteId).delete();
  //   _notes.removeWhere((item) => item.nid == noteId);
  //   notifyListeners();
  // }

  Future<void> update(Note note) async {
    note = Note.clone(note);
    await firestoreCollection.doc(note.nid).set(note.toMap());
    int index = _notes.indexWhere((item) => item.nid == note.nid);
    _notes[index] = note;
    await deleteNoteNotification(note);
    await setNoteNotificacion(note);
  }

  updateStatus(Note note, int newStatus) async {
    final Map<String, dynamic> mapStatus = {'status': newStatus};
    if (newStatus == NoteStatus.deleted) {
      mapStatus['deletedDate'] = FieldValue.serverTimestamp();
      await deleteNoteNotification(note);
    }

    firestoreCollection
        .doc(note.nid)
        .update(mapStatus)
        .catchError((_) => EasyLoading.showError('Error al mover la nota'));
    _notes.removeWhere((item) => item.nid == note.nid);
    Future.delayed(const Duration(milliseconds: 50))
        .whenComplete(notifyListeners);
  }

  swipeFavourite(Note note) async {
    note.isFavourite = !note.isFavourite;
    note.position = topPosition();
    int index = _notes.indexWhere((item) => item.nid == note.nid);
    _notes[index] = note;
    final mapFavourite = {
      'isFavourite': note.isFavourite,
      'position': note.position!,
    };
    firestoreCollection
        .doc(note.nid)
        .update(mapFavourite)
        .catchError((_) => EasyLoading.showError('Error al editar la nota'));
    sortNotes();
  }

  sortNotes() {
    _notes.sort((Note a, Note b) => (a.isFavourite == b.isFavourite)
        ? b.position!.compareTo(a.position!)
        : a.isFavourite
            ? -1
            : 1);
    notifyListeners();
  }

  reorder(int oldIndex, int newIndex) {
    late Note noteToReorder;
    if (newIndex == 0 || _notes[newIndex - 1].isFavourite) {
      _notes[oldIndex].position = topPosition();
    } else if (newIndex == _notes.length) {
      _notes[oldIndex].position = _notes.last.position! - 1000;
    } else if (newIndex > _notes.length) {
      return;
    } else {
      double media =
          (_notes[newIndex].position! + _notes[newIndex - 1].position!) / 2;

      _notes[oldIndex].position = media;
    }
    if (newIndex < _notes.length) {
      _notes[oldIndex].isFavourite = _notes[newIndex].isFavourite;
    }
    noteToReorder = _notes.removeAt(oldIndex);
    _notes.insert(
        newIndex <= oldIndex ? newIndex : newIndex - 1, noteToReorder);
    final mapPosition = {
      'position': noteToReorder.position!,
      'isFavourite': noteToReorder.isFavourite,
    };
    firestoreCollection
        .doc(noteToReorder.nid)
        .update(mapPosition)
        .catchError((_) => EasyLoading.showError('Error al editar la nota'));
    notifyListeners();
  }

  removeOldDeletedNotes() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 7));
    final String? uid = AuthService().currentUser?.uid;

    final QuerySnapshot notesSnapshot = await firestoreCollection
        .where("status", isEqualTo: NoteStatus.deleted)
        .where("uid", isEqualTo: uid)
        .where("deletedDate", isLessThan: yesterday)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in notesSnapshot.docs) {
      // final Map<String, dynamic> noteMap = doc.data()! as Map<String, dynamic>;
      // print('DELETE OLD TRASH ${noteMap['title']}');
      batch.delete(doc.reference);
    }

    await batch.commit().catchError((_) =>
        EasyLoading.showError('Error al eliminar las notas de la papelera'));
  }

  set selectedNote(Note? selectedNote) {
    _selectedNote = selectedNote != null ? Note.fromObject(selectedNote) : null;
    notifyListeners();
  }

  Note? get selectedNote {
    return _selectedNote;
  }

  int? get currentStauts {
    return _currentStatus;
  }

  set currentStauts(int? status) {
    _currentStatus = status;
    load(status!);
  }

  set search(String? searchText) {
    _filters.search = searchText;
    notifyListeners();
  }

  Category? get currentCategory {
    return _filters.category;
  }

  set currentCategory(Category? category) {
    _filters.category = category;
    notifyListeners();
  }
}
