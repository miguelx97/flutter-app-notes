import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/models/category.dart';

import '../global/mockups.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory;

  CategoriesProvider() {
    _categories = Mockups.categories;
  }

  getAll() {
    return _categories;
  }

  insert(Category category) {
    _categories.insert(0, category);
    notifyListeners();
  }

  delete(String categoryId) {
    _categories.removeWhere((item) => item.id == categoryId);
    notifyListeners();
  }

  set selectedCategory(Category? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }

  Category? get selectedCategory {
    return _selectedCategory;
  }
}
