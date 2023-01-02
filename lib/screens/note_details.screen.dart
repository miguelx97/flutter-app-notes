import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/notes.provider.dart';

class NoteDetailsScreen extends StatelessWidget {
  const NoteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    final Note note = notesProvider.selectedNote!;
    return Scaffold(
      body: Container(
        child: Column(
          children: [Text(note.title)],
        ),
      ),
    );
  }
}
