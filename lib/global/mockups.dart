import '../models/category.dart';
import '../models/note.dart';

class Mockups {
  static final List<Category> categories = [
    Category(id: "1qwde", title: "Salud", emoji: "🏥"),
    Category(id: "3ewfa", title: "Trabajo", emoji: "💾"),
    Category(id: "hfggg", title: "Salud", emoji: "🏥"),
    Category(id: "fsdsf", title: "Trabajo", emoji: "💾"),
    Category(id: "vsref", title: "Salud", emoji: "🏥"),
    Category(id: "gfsfd", title: "Trabajo", emoji: "💾"),
    Category(id: "fsdff", title: "Salud", emoji: "🏥"),
  ];

  static final Note note = Note(
    id: 'abcd',
    title: 'Ir al dentista',
    description: 'Tengo que ir al dentista',
    userId: 'abcd',
    date: DateTime.now(),
  );

  static final List<Note> notes = [note, note, note, note, note, note, note];
}
