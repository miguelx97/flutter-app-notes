import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/models/note_status.enum.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:flutter_app_notas/screens/add_note.screen.dart';
import 'package:flutter_app_notas/screens/categories-management.screen.dart';
import 'package:flutter_app_notas/screens/note_details.screen.dart';
import 'package:flutter_app_notas/services/auth.service.dart';
import 'package:flutter_app_notas/widgets/note-item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/category_picker_slider.dart';

class HomeScreen extends StatelessWidget {
  final DateTime now = DateTime.now();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: EasySearchBar(
        // automaticallyImplyLeading: false,
        title: Text(
          Utils.dateFormat(now),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.calendar_today_outlined),
          //     color: Colors.white),
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.search_outlined),
          //     color: Colors.white),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
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
        onPressed: () {
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
  return Row(children: [Icon(icon), SizedBox(width: 5), Text(label)]);
}

class Body extends StatelessWidget {
  final NotesProvider notesProvider;

  const Body({super.key, required this.notesProvider});

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final List<Note> notes = notesProvider.getAll();

    return Center(
      child: Container(
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
              notesProvider.selectedNote = note;
              context.go('${NoteDetailsScreen.screenUrl}/${note.nid}');
            },
            key: ValueKey(notes[index]),
          ),
          onReorder: notesProvider.reorder,
        ),
      ),
    );
  }
}

enum ItemName { deleted, logout }
