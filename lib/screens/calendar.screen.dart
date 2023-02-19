import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/note.dart';
import '../providers/notes.provider.dart';

class CalendarScreen extends StatelessWidget {
  static const screenUrl = '/calendar';
  static Map<DateTime, List<Event>> events = new Map();

  const CalendarScreen({super.key});

  List<Event> _getEventsForDay(DateTime day) {
    final DateTime date = new DateTime(day.year, day.month, day.day);
    return events[date] ?? [];
  }

  void notesToEvents(Note note) {
    if (note.date != null) {
      final DateTime date =
          new DateTime(note.date!.year, note.date!.month, note.date!.day);
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(Event(note.title));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    notesProvider.clearFilters();
    events.clear();
    notesProvider.getAll().forEach(notesToEvents);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.noteAdd,
          style: textTheme.headlineMedium,
        ),
      ),
      body: Container(
        child: TableCalendar(
          firstDay: now.subtract(Duration(days: 60)),
          lastDay: now.add(Duration(days: 730)),
          startingDayOfWeek: StartingDayOfWeek.monday,
          focusedDay: now,
          locale: 'es_ES',
          eventLoader: _getEventsForDay,
        ),
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
