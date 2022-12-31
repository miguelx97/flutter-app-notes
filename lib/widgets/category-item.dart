import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/models/category.dart';

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
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 1,
        color: isSelected ? ThemeColors.pimary : ThemeColors.lightBlue,
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
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
