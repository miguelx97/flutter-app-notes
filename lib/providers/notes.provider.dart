import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/global/mockups.dart';
import 'package:flutter_app_notas/models/note.dart';

import '../services/auth.service.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

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
    _notes.removeWhere((item) => item.id == noteId);
    notifyListeners();
  }
}
