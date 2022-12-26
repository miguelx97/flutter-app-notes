import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/models/category.dart';
import 'package:flutter_app_notas/services/auth.service.dart';

import '../global/mockups.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];

  CategoriesProvider() {
    _categories = Mockups.categories;
  }

  getAll() {
    return _categories;
  }

  insert(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  delete(String categoryId) {
    _categories.removeWhere((item) => item.id == categoryId);
    notifyListeners();
  }
}
