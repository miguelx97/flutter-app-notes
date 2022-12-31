import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/note.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:flutter_app_notas/services/auth.service.dart';
import 'package:flutter_app_notas/widgets/note-item.dart';
import 'package:provider/provider.dart';

import '../widgets/category_picker_slider.dart';

class HomeScreen extends StatelessWidget {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, 'categories', arguments: null),
              icon: const Icon(Icons.folder_outlined),
              color: Colors.white),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_outlined),
              color: Colors.white),
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
                default:
              }
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Pendiente',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Hecho'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.add_rounded,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add-note', arguments: null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Body(),
    );
  }
}

Row MenuItem({required String label, required IconData icon}) {
  return Row(children: [Icon(icon), SizedBox(width: 5), Text(label)]);
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final List<Note> notes = notesProvider.getAll();
    final categories = categoriesProvider.getAll();

    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ReorderableListView.builder(
        itemCount: notes.length,
        header: CategoriesPickerSlider(
          onCategorySelected: () {},
        ),
        itemBuilder: (context, index) => NoteItem(
          note: notes[index],
          categoryEmoji:
              categoriesProvider.searchEmojiById(notes[index].categoryId),
          key: ValueKey(notes[index]),
        ),
        onReorder: (int oldIndex, int newIndex) {},
      ),
    ));
  }
}

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'categories', arguments: null);
        },
        mini: true,
        heroTag: 'secondary-floating-button',
        child: const Icon(
          Icons.folder_outlined,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10),
      FloatingActionButton(
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.add_rounded,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add-note', arguments: null);
        },
      ),
    ]);
  }
}

enum ItemName { deleted, logout }
