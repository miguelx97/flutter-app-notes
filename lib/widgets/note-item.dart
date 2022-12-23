import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                child: Row(
                  children: [
                    Text("🏥", style: TextStyle(fontSize: 32)),
                    SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10),
                          Text(Utils.dateFormat(note.date!),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black45))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Icon(Icons.star, color: Colors.amber),
        ],
      ),
    );
  }
}
