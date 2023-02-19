import 'category.dart';

class NoteFilters {
  Category? category;
  String? search;

  void clear() {
    category = null;
    search = null;
  }
}
