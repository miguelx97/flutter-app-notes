import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/providers/calendar.provider.dart';
import 'package:taskii/screens/note_details.screen.dart';
import 'package:taskii/widgets/note-item.dart';

import '../models/note.dart';
import '../providers/categories.provider.dart';
import '../providers/notes.provider.dart';

class CalendarScreen extends StatelessWidget {
  static const screenUrl = '/calendar';

  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarProvider(),
      child: NotesCalendar(),
    );
  }
}

class NotesCalendar extends StatelessWidget {
  const NotesCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context);

    notesProvider.clearFilters();
    calendarProvider.clearEvents();
    notesProvider.getAll().forEach(calendarProvider.notesToEvents);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.myCalendar,
          style: textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: TableCalendar(
              firstDay: now.subtract(Duration(days: 60)),
              lastDay: now.add(Duration(days: 730)),
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: calendarProvider.selectedDay,
              selectedDayPredicate: (day) {
                return calendarProvider.getDateFromDatetime(day) ==
                    calendarProvider.selectedDay;
              },
              locale: 'es_ES',
              eventLoader: calendarProvider.getNotesForDay,
              onDaySelected: calendarProvider.setSelectedDate,
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: ThemeColors.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.primary),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: ThemeColors.dark),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.primary,
                ),
              ),
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ListNotesByDay(
              calendarProvider: calendarProvider,
              categoriesProvider: categoriesProvider,
            ),
          )
        ]),
      ),
    );
  }
}

class ListNotesByDay extends StatelessWidget {
  const ListNotesByDay({
    Key? key,
    required this.calendarProvider,
    required this.categoriesProvider,
  }) : super(key: key);

  final CalendarProvider calendarProvider;
  final CategoriesProvider categoriesProvider;

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = calendarProvider.getNotesForDay(null);
    return ListView.builder(
        itemCount: notes.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => NoteItem(
            note: notes[index],
            categoryEmoji: categoriesProvider
                .searchCategoryById(notes[index].categoryId)
                .emoji,
            onNoteSelected: () => context
                .go('${NoteDetailsScreen.screenUrl}/${notes[index].nid}'),
            onSwipe: (Note note, int newStatus) {}));
  }
}
