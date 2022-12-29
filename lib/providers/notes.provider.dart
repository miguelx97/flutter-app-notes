import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/global/mockups.dart';
import 'package:flutter_app_notas/models/note.dart';

import '../services/auth.service.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  Note? _selectedNote;

  NotesProvider() {
    _notes = Mockups.notes;
  }

  getAll() {
    return _notes;
  }

  insert(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  delete(String noteId) {
    _notes.removeWhere((item) => item.nid == noteId);
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
