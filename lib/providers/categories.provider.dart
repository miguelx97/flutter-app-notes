import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_notas/services/auth.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../global/ui.dart';

class CategoriesProvider extends ChangeNotifier {
  final List<Category> _categories = [];
  final Map<String, Category> _categoriesMap = {};
  Category? _selectedCategory;
  final CollectionReference firestoreCollection =
      FirebaseFirestore.instance.collection("categories");

  CategoriesProvider() {
    // _categories = Mockups.categories;
    load();
  }

  List<Category> getAll() {
    return _categories;
  }

  load() async {
    final String? uid = AuthService().currentUser?.uid;
    final QuerySnapshot categoriesSnapshot = await firestoreCollection
        .where("uid", isEqualTo: uid)
        .orderBy("position", descending: true)
        .get();
    for (var doc in categoriesSnapshot.docs) {
      final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      final Category category = Category.fromMap(data);
      category.cid = doc.id;
      _categories.add(category);
      addCategoryMap(category);
    }
    notifyListeners();
  }

  insert(Category category) async {
    EasyLoading.show(status: 'Creando categoría...');
    try {
      category.uid = AuthService().currentUser?.uid;
      category.position = DateTime.now().millisecondsSinceEpoch.toDouble();
      DocumentReference doc = await firestoreCollection.add(category.toMap());
      category.cid = doc.id;
      _categories.insert(0, category);
      // EasyLoading.showSuccess('Categoría creada');
    } on Exception catch (ex) {
      showError(ex, defaultMessage: 'Error al crear la categoría');
    }
    addCategoryMap(category);
    EasyLoading.dismiss();
    notifyListeners();
  }

  delete(String categoryId) async {
    await firestoreCollection.doc(categoryId).delete();
    _categories.removeWhere((item) => item.cid == categoryId);
    _categoriesMap.remove(categoryId);
    notifyListeners();
  }

  update(Category category) async {
    EasyLoading.show(status: 'Modificando categoría...');
    try {
      await firestoreCollection.doc(category.cid).set(category.toMap());
      int index = _categories.indexWhere((item) => item.cid == category.cid);
      _categories[index] = category;
      addCategoryMap(category);
      // EasyLoading.showSuccess('Categoría modificada');
    } on Exception catch (ex) {
      showError(ex, defaultMessage: 'Error al modificar la categoría');
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  addCategoryMap(Category category) => _categoriesMap[category.cid!] =
      Category(title: category.title, emoji: category.emoji);

  reorder(int oldIndex, int newIndex) {
    late Category categoryToReorder;
    if (newIndex == 0) {
      _categories[oldIndex].position = _categories[0].position! + 1000;
    } else if (newIndex == _categories.length) {
      _categories[oldIndex].position = _categories.last.position! - 1000;
    } else if (newIndex > _categories.length) {
      return;
    } else {
      double media = (_categories[newIndex].position! +
              _categories[newIndex - 1].position!) /
          2;
      _categories[oldIndex].position = media;
    }
    categoryToReorder = _categories.removeAt(oldIndex);
    _categories.insert(
        newIndex < oldIndex ? newIndex : newIndex - 1, categoryToReorder);
    final Map<String, double> mapPosition = {
      'position': categoryToReorder.position!
    };
    firestoreCollection
        .doc(categoryToReorder.cid)
        .update(mapPosition)
        .catchError(
            (_) => EasyLoading.showError('Error al reordenar la categoría'));
  }

  Category searchCategoryById(String? cid) {
    if (cid == null || !_categoriesMap.containsKey(cid)) {
      return Category(title: '', emoji: '⚪');
    }
    return _categoriesMap[cid]!;
  }

  set selectedCategory(Category? selectedCategory) {
    _selectedCategory =
        selectedCategory != null ? Category.fromObject(selectedCategory) : null;
    notifyListeners();
  }

  Category? get selectedCategory {
    return _selectedCategory;
  }
}
