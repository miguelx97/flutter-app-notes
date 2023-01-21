import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/models/category.dart';
import 'package:taskii/models/reminder_time.dart';
import 'package:taskii/screens/add_note.screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    updateSubtask(bool? checked, int subtaskIndex) {
      final subtask = note.subtasks.removeAt(subtaskIndex);
      subtask!.checked = checked!;
      if (checked) {
        int countChecked = note.subtasks.where((item) => !item!.checked).length;
        note.subtasks.insert(countChecked, subtask);
      } else {
        note.subtasks.insert(0, subtask);
      }
      notesProvider.updateSubtask(note);
    }

    checkOrUncheckEverithing(bool checkedAll) {
      note.subtasks = note.subtasks.map((subtask) {
        subtask!.checked = checkedAll;
        return subtask;
      }).toList();
      notesProvider.updateSubtask(note);
    }

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
        _TextAreaItem(
          title: AppLocalizations.of(context)!.noteDescription,
          content: note.description,
          icon: Icons.article_outlined,
        ),
        _SubtasksItem(
          title: AppLocalizations.of(context)!.noteSubtasksList,
          subtasks: note.subtasks,
          icon: Icons.task_outlined,
          onSubtaskChecked: updateSubtask,
          checkOrUncheckEverithing: checkOrUncheckEverithing,
        ),
        _SimpleItem(
          title: AppLocalizations.of(context)!.noteCategory,
          content: noteCategory.title.isNotEmpty
              ? '${noteCategory.emoji} ${noteCategory.title}'
              : null,
          icon: Icons.apps_rounded,
        ),
        _SimpleItem(
          title: AppLocalizations.of(context)!.noteDateTime,
          content: Utils.dateTimeFormat(note.date, hasTime: note.hasTime),
          icon: Icons.calendar_month_outlined,
        ),
        _SimpleItem(
          title: AppLocalizations.of(context)!.noteNotification,
          content: note.reminderTime > 0
              ? ReminderTime.getLabel(note.reminderTime)
              : null,
          icon: Icons.access_alarm,
        ),
      ])),
      floatingActionButton: FloatingButtons(
        note: note,
        mainButtonClick: () => context.push(AddNote.screenUrl),
        secondaryButtonClick: () {
          notesProvider.swipeFavourite(note);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _SimpleItem extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  const _SimpleItem({
    required this.title,
    this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (content == null || content!.isEmpty)
      return Container();
    else {
      return _Item(title: title, icon: icon, child: Text(content!));
    }
  }
}

class _TextAreaItem extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  const _TextAreaItem({
    required this.title,
    this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (content == null || content!.isEmpty)
      return Container();
    else {
      final size = MediaQuery.of(context).size;
      Widget textArea = SizedBox(
          width: (size.width < Constants.maxWidth
                  ? size.width
                  : Constants.maxWidth) -
              150,
          child: Text(content!,
              style: textTheme.bodyMedium, textAlign: TextAlign.justify));
      return _Item(title: title, icon: icon, child: textArea);
    }
  }
}

class _SubtasksItem extends StatelessWidget {
  final String title;
  final List<SubTask?> subtasks;
  final IconData icon;
  final Function(bool?, int subtaskItem) onSubtaskChecked;
  final Function(bool checked) checkOrUncheckEverithing;
  const _SubtasksItem({
    required this.title,
    required this.subtasks,
    required this.icon,
    required this.onSubtaskChecked,
    required this.checkOrUncheckEverithing,
  });

  @override
  Widget build(BuildContext context) {
    int countChecked = subtasks.where((item) => item!.checked).length;
    if (subtasks.isEmpty)
      return Container();
    else {
      final size = MediaQuery.of(context).size;
      Widget subtasksList = Container(
        width: size.width - 80,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: subtasks.length,
              itemBuilder: (context, index) => SubtaskItem(
                subtasks[index]!,
                index,
                onSubtaskChecked,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => checkOrUncheckEverithing(countChecked == 0),
                child: Text(countChecked > 0
                    ? AppLocalizations.of(context)!.clean
                    : AppLocalizations.of(context)!.complete),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -2)),
              ),
            )
          ],
        ),
      );
      return _Item(title: title, icon: icon, child: subtasksList);
    }
  }
}

class SubtaskItem extends StatelessWidget {
  final SubTask subtask;
  final int index;
  final Function(bool?, int subtaskItem) onSubtaskChecked;
  const SubtaskItem(this.subtask, this.index, this.onSubtaskChecked);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: CheckboxListTile(
        value: subtask.checked,
        title: Text(
          subtask.title,
          style: TextStyle(
              decoration: subtask.checked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        activeColor: ThemeColors.medium,
        onChanged: (value) => onSubtaskChecked(value, index),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  const _Item({
    required this.title,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
              child
            ],
          ),
        ],
      ),
    );
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
