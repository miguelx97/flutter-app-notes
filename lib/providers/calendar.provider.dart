import 'package:flutter/material.dart';

import '../models/note.dart';

class CalendarProvider extends ChangeNotifier {
  final Map<DateTime, List<Note>> _notesByDay = new Map();
  DateTime _selectedDate = DateTime.now();

  List<Note> getNotesForDay(DateTime? day) {
    if (day == null) day = _selectedDate;

    final DateTime date = getDateFromDatetime(day);
    return _notesByDay[date] ?? [];
  }

  void notesToEvents(Note note) {
    if (note.date != null) {
      final DateTime date = getDateFromDatetime(note.date!);
      if (_notesByDay[date] == null) {
        _notesByDay[date] = [];
      }
      _notesByDay[date]!.add(note);
    }
  }

  clearEvents() => _notesByDay.clear();

  setSelectedDate(DateTime selectedDay, DateTime focusedDay) {
    _selectedDate = getDateFromDatetime(focusedDay);
    notifyListeners();
  }

  get selectedDay {
    return _selectedDate;
  }

  getDateFromDatetime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
