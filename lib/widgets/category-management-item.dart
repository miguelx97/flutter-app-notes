import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/models/category.dart';

class CategoryManagementItem extends StatelessWidget {
  final Category category;
  final Function delete;
  final Function update;
  const CategoryManagementItem({
    super.key,
    required this.category,
    required this.delete,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(category.emoji),
                  const SizedBox(width: 10),
                  Text(category.title),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => update(category),
                      icon: const Icon(Icons.edit_outlined),
                      color: ThemeColors.tertiary),
                  IconButton(
                      onPressed: () => delete(category),
                      icon: const Icon(Icons.delete_outline),
                      color: ThemeColors.danger),
                  const SizedBox(width: 10)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
