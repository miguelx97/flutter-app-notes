import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/models/note_status.enum.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final String categoryEmoji;
  final Function onNoteSelected;
  const NoteItem(
      {super.key,
      required this.note,
      required this.categoryEmoji,
      required this.onNoteSelected});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Dismissible(
      key: ValueKey(note.nid),
      background:
          Swipe(status: note.status!, direction: DismissDirection.startToEnd),
      secondaryBackground:
          Swipe(status: note.status!, direction: DismissDirection.endToStart),
      onDismissed: (direction) {},
      child: GestureDetector(
        onTap: () => onNoteSelected(note),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
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
                                      Utils.dateTimeFormat(
                                          note.date, note.hasTime),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black45)),
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
                child: Icon(Icons.star, color: Colors.amber),
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
    late SwipeUi swipeUi;
    final SwipeUi doneSwipe =
        SwipeUi(icon: Icons.done, color: ThemeColors.success);
    final SwipeUi pendingSwipe =
        SwipeUi(icon: Icons.house, color: ThemeColors.primaryDark);
    final SwipeUi deleteSwipe =
        SwipeUi(icon: Icons.delete, color: ThemeColors.danger);

    if (direction == DismissDirection.startToEnd) {
      alignment = Alignment.centerLeft;
      switch (status) {
        case NoteStatus.pending:
          swipeUi = doneSwipe;
          break;
        case NoteStatus.done:
          swipeUi = deleteSwipe;
          break;
        case NoteStatus.deleted:
          swipeUi = doneSwipe;
          break;
      }
    } else if (direction == DismissDirection.endToStart) {
      alignment = Alignment.centerRight;
      switch (status) {
        case NoteStatus.pending:
          swipeUi = deleteSwipe;
          break;
        case NoteStatus.done:
          swipeUi = pendingSwipe;
          break;
        case NoteStatus.deleted:
          swipeUi = pendingSwipe;
          break;
      }
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
  IconData icon;
  Color color;
  SwipeUi({required this.icon, required this.color});
}
