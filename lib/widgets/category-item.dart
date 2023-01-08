import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 1,
        color: isSelected ? ThemeColors.primary : ThemeColors.lightBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                category.emoji,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                category.title,
                style: textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
