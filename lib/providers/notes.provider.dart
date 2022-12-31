import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/global/mockups.dart';
import 'package:flutter_app_notas/models/note.dart';

import '../services/auth.service.dart';

class NotesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Note> _notes = [];
  Note? _selectedNote = Note();
  final CollectionReference firestoreCollection =
      FirebaseFirestore.instance.collection("notes");

  NotesProvider() {
    _notes = Mockups.notes;
  }

  getAll() {
    return _notes;
  }

  insert(Note note) async {
    note.uid = AuthService().currentUser?.uid;
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
