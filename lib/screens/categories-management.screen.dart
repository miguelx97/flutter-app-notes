import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/widgets/category-form.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../widgets/category-management-item.dart';

class CategoriesManagement extends StatelessWidget {
  const CategoriesManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.getAll();
    bool hasSelectedCategory = categoriesProvider.selectedCategory != null;

    showHideForm() {
      if (hasSelectedCategory) {
        categoriesProvider.selectedCategory = null;
      } else {
        categoriesProvider.selectedCategory =
            Category(title: '', emoji: '', id: '');
      }
    }

    updateCategory(Category category) {
      categoriesProvider.selectedCategory = Category.fromObject(category);
    }

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
        itemCount: categories.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return CategoryForm();
          } else {
            return CategoryManagementItem(
              category: categories[index - 1],
              delete: categoriesProvider.delete,
              update: updateCategory,
            );
          }
        },
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: showHideForm,
        heroTag: 'main-floating-button',
        child: RotationTransition(
          turns: AlwaysStoppedAnimation((hasSelectedCategory ? 45 : 0) / 360),
          child: const Icon(
            Icons.add_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
