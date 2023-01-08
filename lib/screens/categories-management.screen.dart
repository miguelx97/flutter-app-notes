import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/widgets/category-form.dart';
import 'package:go_router/go_router.dart';
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

    if (categories.isEmpty && categoriesProvider.selectedCategory == null) {
      Future.delayed(const Duration(milliseconds: 200))
          .whenComplete(showHideForm);
    }

    updateCategory(Category category) {
      categoriesProvider.selectedCategory = Category.fromObject(category);
    }

    deleteCategory(Category category) {
      // set up the buttons
      Widget cancelButton =
          TextButton(child: Text("Cancelar"), onPressed: () => context.pop());
      Widget continueButton = TextButton(
        child: Text("Eliminar"),
        onPressed: () {
          context.pop();
          categoriesProvider.delete(category.cid!);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Eliminar categoría"),
        content:
            Text("¿Estás seguro de que deseas eliminar '${category.title}'?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Categorías",
          style: textTheme.headlineMedium,
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
                  delete: deleteCategory,
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
