import 'dart:convert';

class Note {
  Note({
    required this.id,
    required this.title,
    this.description,
    this.date,
    this.categoryId,
    this.reminderTime,
    required this.userId,
  });

  String id;
  String title;
  String? description;
  DateTime? date;
  int? categoryId;
  int? reminderTime;
  String userId;

  factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        categoryId: json["categoryId"],
        reminderTime: json["reminderTime"],
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "date": date?.toIso8601String(),
        "categoryId": categoryId,
        "reminderTime": reminderTime,
        "userId": userId,
      };
}




/**
{
    "id":"1",
    "title":"dentista",
    "description":"ir al dentista",
    "date":"1944-06-06 02:00:00.000",
    "categoryId":2,
    "reminderTime":897,
    "userId":"dasdasdasdas"
}
 */