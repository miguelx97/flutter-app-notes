import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/models/category.dart';
import 'package:taskii/models/reminder_time.dart';
import 'package:taskii/screens/add_note.screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../global/utils.dart';
import '../models/note.dart';
import '../providers/categories.provider.dart';
import '../providers/notes.provider.dart';

class NoteDetailsScreen extends StatelessWidget {
  static const String screenUrl = '/note-details';
  final String nid;
  static bool _loadingNoteFromServer = false;
  const NoteDetailsScreen({super.key, required this.nid});

  @override
  Widget build(BuildContext context) {
    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final Note note = notesProvider.selectedNote!;
    if (note.nid == null && !_loadingNoteFromServer) {
      notesProvider
          .selectedNoteById(nid)
          .then((_) => _loadingNoteFromServer = false);
      _loadingNoteFromServer = true;
    }
    final Category noteCategory =
        categoriesProvider.searchCategoryById(note.categoryId);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            color: ThemeColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, -1), // changes position of shadow
              ),
            ],
          ),
          child: Text(note.title,
              style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Kalam',
                  color: Colors.white,
                  letterSpacing: 1),
              textAlign: TextAlign.center),
        ),
        SizedBox(height: 10),
        _Item(
          title: 'Descripción',
          content: note.description,
          icon: Icons.article_outlined,
          isTextArea: true,
        ),
        _Item(
          title: 'Categoría',
          content: noteCategory.title.isNotEmpty
              ? '${noteCategory.emoji} ${noteCategory.title}'
              : null,
          icon: Icons.apps_rounded,
        ),
        _Item(
          title: 'Fecha / Hora',
          content: Utils.dateTimeFormat(note.date, hasTime: note.hasTime),
          icon: Icons.calendar_month_outlined,
        ),
        _Item(
          title: 'Recordatorio',
          content: note.reminderTime > 0
              ? ReminderTime.getLabel(note.reminderTime)
              : null,
          icon: Icons.access_alarm,
        ),
      ])),
      floatingActionButton: FloatingButtons(
        note: note,
        mainButtonClick: () => context.go(AddNote.screenUrl),
        secondaryButtonClick: () {
          notesProvider.swipeFavourite(note);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final bool isTextArea;
  const _Item(
      {super.key,
      required this.title,
      required this.content,
      required this.icon,
      this.isTextArea = false});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if ((content ?? '').isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        width: Constants.maxWidth,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: ThemeColors.lightGrey),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleSmall),
                const SizedBox(height: 5),
                TextContent(
                  content: content!,
                  textTheme: textTheme,
                  isTextArea: isTextArea,
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.content,
    required this.textTheme,
    required this.isTextArea,
  }) : super(key: key);

  final String content;
  final TextTheme textTheme;
  final bool isTextArea;

  @override
  Widget build(BuildContext context) {
    if (!isTextArea) return Text(content);
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: (size.width < Constants.maxWidth
                ? size.width
                : Constants.maxWidth) -
            150,
        child: Text(content,
            style: textTheme.bodyMedium, textAlign: TextAlign.justify));
  }
}

class FloatingButtons extends StatelessWidget {
  final Note note;
  final Function mainButtonClick;
  final Function secondaryButtonClick;
  const FloatingButtons({
    Key? key,
    required this.note,
    required this.mainButtonClick,
    required this.secondaryButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
        onTap: () => secondaryButtonClick(),
        child: Icon(
          note.isFavourite ? Icons.star : Icons.star_outline,
          color: Colors.amber,
          size: 35,
        ),
      ),
      const SizedBox(height: 30),
      FloatingActionButton(
        onPressed: () => mainButtonClick(),
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.edit_outlined,
          size: 35,
          color: Colors.white,
        ),
      ),
    ]);
  }
}
