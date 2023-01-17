import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/global/ui.dart';
import 'package:taskii/models/note.dart';
import 'package:taskii/models/note_status.enum.dart';
import 'package:taskii/providers/categories.provider.dart';
import 'package:taskii/providers/notes.provider.dart';
import 'package:taskii/screens/add_note.screen.dart';
import 'package:taskii/screens/categories-management.screen.dart';
import 'package:taskii/screens/note_details.screen.dart';
import 'package:taskii/services/analytics.service.dart';
import 'package:taskii/services/auth.service.dart';
import 'package:taskii/widgets/note-item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/category_picker_slider.dart';

class HomeScreen extends StatelessWidget {
  final DateTime now = DateTime.now();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    initAnalytics(AuthService().currentUser);
    return Scaffold(
      appBar: EasySearchBar(
        // automaticallyImplyLeading: false,
        title: Text(
          DateFormat.yMMMd('es').format(now),
          style: textTheme.headlineMedium,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ItemName.deleted,
                child:
                    MenuItem(label: "Eliminados", icon: Icons.delete_outline),
              ),
              PopupMenuItem(
                value: ItemName.logout,
                child: MenuItem(
                    label: "Cerrar sesión", icon: Icons.logout_outlined),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case ItemName.logout:
                  AuthService().signOut();
                  break;
                case ItemName.deleted:
                  notesProvider.currentStauts = NoteStatus.deleted;
                  break;
                default:
              }
            },
          ),
          IconButton(
              onPressed: () => context.go(CategoriesManagement.screenUrl),
              icon: const Icon(Icons.folder_outlined),
              color: Colors.white),
        ],
        onSearch: (String search) {
          notesProvider.search = search;
        },
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: Footer(notesProvider: notesProvider),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.add_rounded,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () async {
          notesProvider.selectedNote = Note();
          notesProvider.selectedNote!.categoryId =
              notesProvider.currentCategory?.cid;
          context.go(AddNote.screenUrl);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Body(notesProvider: notesProvider),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
    required this.notesProvider,
  }) : super(key: key);

  final NotesProvider notesProvider;

  @override
  Widget build(BuildContext context) {
    final int status = notesProvider.currentStauts ?? NoteStatus.pending;
    return BottomNavigationBar(
      currentIndex: (status <= 1) ? 0 : 1,
      onTap: (value) => notesProvider.currentStauts = value + 1,
      selectedItemColor:
          (status <= 2) ? ThemeColors.primary : ThemeColors.medium,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Pendiente',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: 'Hecho',
        ),
      ],
    );
  }
}

Row MenuItem({required String label, required IconData icon}) {
  return Row(children: [
    Icon(icon, color: ThemeColors.primary),
    SizedBox(width: 5),
    Text(label),
  ]);
}

class Body extends StatelessWidget {
  final NotesProvider notesProvider;

  udateStatus(Note note, int newStatus) {
    notesProvider.updateStatus(note, newStatus);
  }

  const Body({super.key, required this.notesProvider});

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final List<Note> notes = notesProvider.getAll();

    if (notes.isEmpty &&
        categoriesProvider.getAll().isEmpty &&
        notesProvider.loadedNotesFromFb) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => context.go(AddNote.screenUrl),
              child:
                  SvgPicture.asset('assets/images/add_note.svg', width: 170)),
          const SizedBox(height: 20),
          const Text('Escribe tu primera nota',
              style: TextStyle(fontSize: 16, color: ThemeColors.medium)),
          const SizedBox(height: 100)
        ],
      ));
    }

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
                showError('No puedes modificar notas eliminadas');
                return;
              }
              notesProvider.selectedNote = note;
              context.go('${NoteDetailsScreen.screenUrl}/${note.nid}');
            },
            onSwipe: udateStatus,
            key: ValueKey(notes[index].nid),
          ),
          onReorder: notesProvider.reorder,
        ),
      ),
    );
  }
}

enum ItemName { deleted, logout }
