import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/utils.dart';
import 'package:taskii/models/note.dart';
import 'package:taskii/models/note_status.enum.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final String categoryEmoji;
  final Function onNoteSelected;
  final Function(Note note, int newStatus) onSwipe;
  const NoteItem(
      {super.key,
      required this.note,
      required this.categoryEmoji,
      required this.onNoteSelected,
      required this.onSwipe});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Dismissible(
      key: ValueKey(note.nid),
      background:
          Swipe(status: note.status!, direction: DismissDirection.startToEnd),
      secondaryBackground:
          Swipe(status: note.status!, direction: DismissDirection.endToStart),
      onDismissed: (direction) {
        final SwipeUi swipe = SwipeUi.swipeType(note.status!, direction);
        onSwipe(note, swipe.status);
      },
      child: GestureDetector(
        onTap: () => onNoteSelected(note),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3, right: 15, left: 15),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 20),
                    child: Row(
                      children: [
                        Text(categoryEmoji, style: TextStyle(fontSize: 32)),
                        SizedBox(width: 15),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: textTheme.titleMedium),
                              Visibility(
                                visible: note.date != null,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                      Utils.dateTimeFormat(note.date,
                                          hasTime: note.hasTime),
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: note.isFavourite,
                child: const Icon(Icons.star, color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Swipe extends StatelessWidget {
  final int status;
  final DismissDirection direction;
  const Swipe({super.key, required this.status, required this.direction});

  @override
  Widget build(BuildContext context) {
    late Alignment alignment;
    final SwipeUi swipeUi = SwipeUi.swipeType(status, direction);
    if (direction == DismissDirection.startToEnd) {
      alignment = Alignment.centerLeft;
    } else if (direction == DismissDirection.endToStart) {
      alignment = Alignment.centerRight;
    }
    return Container(
      color: swipeUi.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: alignment,
          child: Icon(swipeUi.icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class SwipeUi {
  final IconData icon;
  final Color color;
  final int status;
  SwipeUi({required this.icon, required this.color, required this.status});

  static final SwipeUi doneSwipe = SwipeUi(
    icon: Icons.done,
    color: ThemeColors.success,
    status: NoteStatus.done,
  );
  static final SwipeUi pendingSwipe = SwipeUi(
    icon: Icons.house,
    color: ThemeColors.primaryDark,
    status: NoteStatus.pending,
  );
  static final SwipeUi deleteSwipe = SwipeUi(
    icon: Icons.delete,
    color: ThemeColors.danger,
    status: NoteStatus.deleted,
  );

  static SwipeUi swipeType(int status, DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      switch (status) {
        case NoteStatus.pending:
          return doneSwipe;
        case NoteStatus.done:
          return deleteSwipe;
        case NoteStatus.deleted:
          return doneSwipe;
      }
    } else if (direction == DismissDirection.endToStart) {
      switch (status) {
        case NoteStatus.pending:
          return deleteSwipe;
        case NoteStatus.done:
          return pendingSwipe;
        case NoteStatus.deleted:
          return pendingSwipe;
      }
    }
    return SwipeUi(
      icon: Icons.close,
      color: ThemeColors.lightGrey,
      status: NoteStatus.pending,
    );
  }
}
