import '../models/category.dart';
import '../models/note.dart';

class Mockups {
  static final List<Category> categories = [
    Category(id: "12345", title: "Salud", emoji: "🏥"),
    Category(id: "12345", title: "Trabajo", emoji: "💾"),
    Category(id: "12345", title: "Salud", emoji: "🏥"),
    Category(id: "12345", title: "Trabajo", emoji: "💾"),
    Category(id: "12345", title: "Salud", emoji: "🏥"),
    Category(id: "12345", title: "Trabajo", emoji: "💾"),
    Category(id: "12345", title: "Salud", emoji: "🏥"),
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
