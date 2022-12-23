import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';

import '../global/mockups.dart';
import '../models/category.dart';
import '../widgets/category-management-item.dart';

class CategoriesManagement extends StatelessWidget {
  const CategoriesManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = Mockups.notes;
    final categories = Mockups.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categorías",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, index) =>
            CategoryManagementItem(category: categories[index]),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.add_rounded,
          size: 35,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
