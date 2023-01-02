import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/widgets/category-form.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/category.dart';
import '../widgets/category-management-item.dart';

class CategoriesManagement extends StatelessWidget {
  static const String screenUrl = '/categories';
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
        categoriesProvider.selectedCategory = Category(title: '', emoji: '');
      }
    }

    updateCategory(Category category) {
      categoriesProvider.selectedCategory = Category.fromObject(category);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          "Categorías",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
            width: Constants.maxWidth,
            child: ReorderableListView.builder(
              itemCount: categories.length,
              header: CategoryForm(),
              itemBuilder: (_, index) {
                return CategoryManagementItem(
                  key: ValueKey(categories[index]),
                  category: categories[index],
                  delete: categoriesProvider.delete,
                  update: updateCategory,
                );
              },
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
              onReorder: categoriesProvider.reorder,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showHideForm,
        heroTag: 'main-floating-button',
        child: Transform.rotate(
          angle: hasSelectedCategory ? (pi / 4) : 0,
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
