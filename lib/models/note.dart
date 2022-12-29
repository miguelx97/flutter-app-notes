// To parse this JSON data, do
//
//     final note = noteFromMap(jsonString);

import 'dart:convert';

class Note {
  Note({
    this.nid,
    required this.title,
    this.description,
    this.isFavourite = false,
    this.date,
    this.categoryId,
    this.reminderTime,
    this.status,
    this.createionDate,
    this.position,
    this.uid,
  });

  String? nid;
  String title;
  String? description;
  bool isFavourite;
  DateTime? date;
  String? categoryId;
  int? reminderTime;
  int? status;
  int? position;
  DateTime? createionDate;
  String? uid;

  factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        nid: json["nid"],
        title: json["title"],
        description: json["description"],
        isFavourite: json["isFavourite"],
        date: DateTime.parse(json["date"]),
        categoryId: json["categoryId"],
        reminderTime: json["reminderTime"],
        status: json["status"],
        position: json["position"],
        createionDate: DateTime.parse(json["createionDate"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "nid": nid,
        "title": title,
        "description": description,
        "isFavourite": isFavourite,
        "date": date?.toIso8601String(),
        "categoryId": categoryId,
        "reminderTime": reminderTime,
        "status": status,
        "position": position,
        "createionDate": createionDate?.toIso8601String(),
        "uid": uid,
      };
}




/**
{
    "nid":"1",
    "title":"dentista",
    "description":"ir al dentista",
    "isFavourite":false,
    "date":"1944-06-06 02:00:00.000",
    "categoryId":"2",
    "reminderTime":897,
    "status":2,
    "position":1
    "createionDate":"1944-06-06 02:00:00.000",
    "uid":"dasdasdasdas"
}
 */