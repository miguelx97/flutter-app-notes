import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/models/note_status.enum.dart';
import 'package:flutter_app_notas/services/notification.services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    } on Exception catch (ex) {
      EasyLoading.showError('Error al cargar las notas');
    }
    print('Get all notes from firebase: ${_notes.length}');
    // EasyLoading.dismiss();
    notifyListeners();
  }

  insert(Note note) async {
    EasyLoading.show(status: 'Guardando nota...');
    try {
      note = Note.clone(note);
      final now = DateTime.now();
      note.uid = AuthService().currentUser?.uid;
      note.position = now.millisecondsSinceEpoch.toDouble();
      note.status = NoteStatus.pending;
      note.createionDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      DocumentReference doc = await firestoreCollection.add(note.toMap());
      note.nid = doc.id;
      _notes.add(note);
      await setNoteNotificacion(note);
      // EasyLoading.showSuccess('Nota guardada');
    } on Exception catch (ex) {
      EasyLoading.showError('Error al guardar la nota');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  // delete(String noteId) async {
  //   await firestoreCollection.doc(noteId).delete();
  //   _notes.removeWhere((item) => item.nid == noteId);
  //   notifyListeners();
  // }

  update(Note note) async {
    EasyLoading.show(status: 'Actualizando nota...');
    try {
      note = Note.clone(note);
      await firestoreCollection.doc(note.nid).set(note.toMap());
      int index = _notes.indexWhere((item) => item.nid == note.nid);
      _notes[index] = note;
      await deleteNoteNotification(note);
      await setNoteNotificacion(note);
      // EasyLoading.showSuccess('Nota actualizada');
    } on Exception catch (ex) {
      EasyLoading.showError('Error al actualizar la nota');
    }
    EasyLoading.dismiss();
    notifyListeners();
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
    int index = _notes.indexWhere((item) => item.nid == note.nid);
    _notes[index] = note;
    if (note.isFavourite) {
      reorder(index, 0);
    } else {
      final int numberOfFavourites =
          _notes.where((note) => note.isFavourite).length + 1;
      reorder(index, numberOfFavourites);
    }
  }

  reorder(int oldIndex, int newIndex) {
    late Note noteToReorder;
    if (newIndex == 0) {
      _notes[oldIndex].position = _notes[0].position! + 1000;
    } else if (newIndex == _notes.length) {
      _notes[oldIndex].position = _notes.last.position! - 1000;
    } else if (newIndex > _notes.length) {
      return;
    } else {
      //este if es porque se buggeaba al poner un item entre un favorito y un
      //no favorito ya que el favorito podría tener una posición muy baja y aun así estar arriba
      if (_notes[newIndex - 1].position! > _notes[newIndex].position!) {
        double media =
            (_notes[newIndex].position! + _notes[newIndex - 1].position!) / 2;

        _notes[oldIndex].position = media;
      } else {
        _notes[oldIndex].position = _notes[newIndex].position! + 1000;
      }
    }
    _notes[oldIndex].isFavourite = _notes[newIndex].isFavourite;
    noteToReorder = _notes.removeAt(oldIndex);
    _notes.insert(newIndex < oldIndex ? newIndex : newIndex - 1, noteToReorder);
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
    final yesterday = DateTime.now().subtract(const Duration(days: 30));
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
    _selectedNote = selectedNote;
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
