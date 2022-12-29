import 'package:flutter/material.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class AddNote extends StatelessWidget {
  const AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final Note note = notesProvider.selectedNote ?? Note(title: '');
    bool isNew = note.nid == null || note.nid!.isEmpty;

    swipeFavourite() => note.isFavourite = !note.isFavourite;

    return Scaffold(
      appBar: AppBar(title: Text('Añadir nota')),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              initialValue: note.title,
              onChanged: (value) => note.title = value,
              decoration: InputDecoration(
                labelText: 'Nombre de la categoría',
                suffixIcon: IconButton(
                  icon:
                      Icon(note.isFavourite ? Icons.star : Icons.star_outline),
                  onPressed: swipeFavourite,
                ),
              ),
              validator: ((value) {
                return (value == null || value.isEmpty)
                    ? 'Introduce un nombre'
                    : null;
              }),
            )
          ],
        ),
      ),
    );
  }
}
