import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_notas/services/auth.service.dart';

class CategoriesProvider extends ChangeNotifier {
  final List<Category> _categories = [];
  Category? _selectedCategory;
  final CollectionReference firestoreCollection =
      FirebaseFirestore.instance.collection("categories");

  CategoriesProvider() {
    // _categories = Mockups.categories;
    load();
  }

  getAll() {
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
    }
    notifyListeners();
  }

  insert(Category category) async {
    category.uid = AuthService().currentUser?.uid;
    category.position = DateTime.now().millisecondsSinceEpoch;
    DocumentReference doc = await firestoreCollection.add(category.toMap());
    category.cid = doc.id;
    _categories.insert(0, category);
    notifyListeners();
  }

  delete(String categoryId) async {
    await firestoreCollection.doc(categoryId).delete();
    _categories.removeWhere((item) => item.cid == categoryId);
    notifyListeners();
  }

  update(Category category) async {
    await firestoreCollection.doc(category.cid).set(category.toMap());
    int index = _categories.indexWhere((item) => item.cid == category.cid);
    _categories[index] = category;
    notifyListeners();
  }

  reorder(int oldIndex, int newIndex) {
    late Category categoryToReorder;
    if (newIndex == _categories.length) {
      _categories[oldIndex].position = _categories.last.position! - 1;
      categoryToReorder = _categories.removeAt(oldIndex);
      _categories.add(categoryToReorder);
    } else if (newIndex > _categories.length) {
      return;
    } else {
      _categories[oldIndex].position = _categories[newIndex].position! + 1;
      categoryToReorder = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, categoryToReorder);
    }
    firestoreCollection
        .doc(categoryToReorder.cid)
        .set(categoryToReorder.toMap());
  }

  set selectedCategory(Category? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }

  Category? get selectedCategory {
    return _selectedCategory;
  }
}
