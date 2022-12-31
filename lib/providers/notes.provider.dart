import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/global/mockups.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/models/note_status.enum.dart';

import '../services/auth.service.dart';

class NotesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Note> _notes = [];
  Note? _selectedNote = Note();
  final CollectionReference firestoreCollection =
      FirebaseFirestore.instance.collection("notes");

  NotesProvider() {
    // _notes = Mockups.notes;
    load();
  }

  getAll() {
    return _notes;
  }

  load() async {
    final String? uid = AuthService().currentUser?.uid;
    final QuerySnapshot notesSnapshot = await firestoreCollection
        .where("uid", isEqualTo: uid)
        .orderBy("position", descending: true)
        .get();
    for (var doc in notesSnapshot.docs) {
      final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      final Note note = Note.fromMap(data);
      note.nid = doc.id;
      _notes.add(note);
    }
    notifyListeners();
  }

  insert(Note note) async {
    final now = DateTime.now();
    note.uid = AuthService().currentUser?.uid;
    note.createionDate = now;
    note.position = now.millisecondsSinceEpoch;
    note.status = NoteStatus.pending;
    DocumentReference doc = await firestoreCollection.add(note.toMap());
    note.nid = doc.id;
    _notes.add(note);
    notifyListeners();
  }

  delete(String noteId) async {
    await firestoreCollection.doc(noteId).delete();
    _notes.removeWhere((item) => item.nid == noteId);
    notifyListeners();
  }

  update(Note note) async {
    await firestoreCollection.doc(note.uid).set(note.toMap());
    int index = _notes.indexWhere((item) => item.nid == note.nid);
    _notes[index] = note;
    notifyListeners();
  }

  set selectedNote(Note? selectedNote) {
    _selectedNote = selectedNote;
    notifyListeners();
  }

  Note? get selectedNote {
    return _selectedNote;
  }
}
