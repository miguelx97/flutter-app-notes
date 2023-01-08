import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/models/category.dart';

class CategoryManagementItem extends StatelessWidget {
  final Category category;
  final Function delete;
  final Function update;
  final Function(Category category) categorySelect;
  const CategoryManagementItem({
    super.key,
    required this.category,
    required this.delete,
    required this.update,
    required this.categorySelect,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => categorySelect(category),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    Text(category.title, style: textTheme.titleMedium),
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
      ),
    );
  }
}
