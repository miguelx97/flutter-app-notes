import '../models/category.dart';
import '../models/note.dart';

class Mockups {
  static final List<Category> categories = [
    Category(cid: "1qwde", title: "Salud", emoji: "🏥"),
    Category(cid: "3ewfa", title: "Trabajo", emoji: "💾"),
    Category(cid: "hfggg", title: "Salud", emoji: "🏥"),
    Category(cid: "fsdsf", title: "Trabajo", emoji: "💾"),
    Category(cid: "vsref", title: "Salud", emoji: "🏥"),
    Category(cid: "gfsfd", title: "Trabajo", emoji: "💾"),
    Category(cid: "fsdff", title: "Salud", emoji: "🏥"),
  ];

  static final Note note = Note(
    nid: 'abcd',
    title: 'Ir al dentista',
    description: 'Tengo que ir al dentista',
    uid: 'abcd',
    date: DateTime.now(),
  );

  static final List<Note> notes = [note, note, note, note, note, note, note];
}
