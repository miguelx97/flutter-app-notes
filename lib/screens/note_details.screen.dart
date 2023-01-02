import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/models/category.dart';
import 'package:flutter_app_notas/models/reminder_time.dart';
import 'package:flutter_app_notas/screens/add_note.screen.dart';
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
    final TextTheme textTheme = Theme.of(context).textTheme;
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // alignment: Alignment.topLeft,
            // color: Colors.lightBlue,
            width: Constants.maxWidth,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                Text(note.title, style: textTheme.titleLarge),
                SizedBox(height: 30),
                Item(
                  title: 'Descripción',
                  content: note.description,
                  icon: Icons.article_outlined,
                  isTextArea: true,
                ),
                Item(
                  title: 'Categoría',
                  content: noteCategory.title.isNotEmpty
                      ? '${noteCategory.emoji} ${noteCategory.title}'
                      : null,
                  icon: Icons.apps_rounded,
                ),
                Item(
                  title: 'Fecha / Hora',
                  content: Utils.dateTimeFormat(note.date, note.hasTime),
                  icon: Icons.calendar_month_outlined,
                ),
                Item(
                  title: 'Recordatorio',
                  content: note.reminderTime != null
                      ? ReminderTime.getLabel(note.reminderTime!)
                      : null,
                  icon: Icons.access_alarm,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AddNote.screenUrl),
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.edit_outlined,
          size: 35,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Item extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final bool isTextArea;
  const Item(
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
        child: Text(content!,
            style: textTheme.bodyMedium, textAlign: TextAlign.justify));
  }
}
