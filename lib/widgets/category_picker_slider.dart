import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskii/models/category.dart';
import 'package:provider/provider.dart';
import 'package:taskii/screens/categories-management.screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/categories.provider.dart';
import 'category-item.dart';

class CategoriesPickerSlider extends StatelessWidget {
  final Function onCategorySelected;
  final String? idSelectedCategory;
  final bool emptyCategoriesMessage;

  const CategoriesPickerSlider({
    super.key,
    required this.onCategorySelected,
    this.idSelectedCategory,
    this.emptyCategoriesMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final List<Category> categories = categoriesProvider.getAll();
    if (categories.isEmpty) {
      if (emptyCategoriesMessage) {
        return TextButton(
          child:
              Text(AppLocalizations.of(context)!.categoryCreate.toUpperCase()),
          onPressed: () => context.push(CategoriesManagement.screenUrl),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            padding: EdgeInsets.only(left: 15),
          ),
        );
      } else {
        return SizedBox(height: 15);
      }
    }
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
