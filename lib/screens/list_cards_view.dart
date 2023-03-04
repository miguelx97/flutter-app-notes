import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/screens/note_details.screen.dart';
import 'package:taskii/widgets/note-item.dart';

import '../global/ui.dart';
import '../models/note.dart';
import '../models/note_status.enum.dart';
import '../providers/categories.provider.dart';
import '../providers/notes.provider.dart';
import '../widgets/category_picker_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListCardsView extends StatelessWidget {
  const ListCardsView({
    super.key,
    required List<Note> this.notes,
    required Function(Note note, int newStatus) this.updateStatus,
    required NotesProvider this.notesProvider,
    required CategoriesProvider this.categoriesProvider,
  });

  final List<Note> notes;
  final Function(Note note, int newStatus) updateStatus;
  final NotesProvider notesProvider;
  final CategoriesProvider categoriesProvider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Constants.maxWidth,
        child: ReorderableListView.builder(
          itemCount: notes.length,
          header: CategoriesPickerSlider(
            onCategorySelected: (category) =>
                notesProvider.currentCategory = category,
            idSelectedCategory: notesProvider.currentCategory?.cid,
          ),
          itemBuilder: (context, index) => NoteItem(
            note: notes[index],
            categoryEmoji: categoriesProvider
                .searchCategoryById(notes[index].categoryId)
                .emoji,
            onNoteSelected: (Note note) {
              if (note.status == NoteStatus.deleted) {
                showError(
                    AppLocalizations.of(context)!.errorNoteNoUpdateDeleted);
                return;
              }
              notesProvider.selectedNote = note;
              context.go('${NoteDetailsScreen.screenUrl}/${note.nid}');
            },
            onSwipe: updateStatus,
            key: ValueKey(notes[index].nid),
          ),
          onReorder: notesProvider.reorder,
        ),
      ),
    );
  }
}
