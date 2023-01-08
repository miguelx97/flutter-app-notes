import 'package:flutter/material.dart';
import 'package:taskii/models/category.dart';
import 'package:provider/provider.dart';

import '../providers/categories.provider.dart';
import 'category-item.dart';

class CategoriesPickerSlider extends StatelessWidget {
  final Function onCategorySelected;
  final String? idSelectedCategory;

  const CategoriesPickerSlider({
    super.key,
    required this.onCategorySelected,
    this.idSelectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final List<Category> categories = categoriesProvider.getAll();
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) => GestureDetector(
            onTap: () => onCategorySelected(
                categories[index].cid == idSelectedCategory
                    ? null
                    : categories[index]),
            child: CategoryItem(
              category: categories[index],
              isSelected: idSelectedCategory == categories[index].cid,
            ),
          ),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10, right: 5),
        ),
      ),
    );
  }
}
