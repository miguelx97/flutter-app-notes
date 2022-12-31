import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.provider.dart';
import 'category-item.dart';

class CategoriesPickerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final categories = categoriesProvider.getAll();
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) => CategoryItem(category: categories[index]),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10, right: 5),
        ),
      ),
    );
  }
}
