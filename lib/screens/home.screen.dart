import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/mockups.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/widgets/category-item.dart';
import 'package:flutter_app_notas/widgets/note-item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
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
              onPressed: () {},
              icon: const Icon(Icons.delete_outline),
              color: Colors.white),
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, 'categories', arguments: null),
              icon: const Icon(Icons.folder_outlined),
              color: Colors.white),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_outlined),
              color: Colors.white),
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

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = Mockups.notes;
    final categories = Mockups.categories;
    return Container(
        child: ListView.builder(
      itemCount: notes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (_, index) =>
                    CategoryItem(category: categories[index]),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10, right: 5),
              ),
            ),
          );
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: NoteItem(note: notes[index - 1]));
        }
      },
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
