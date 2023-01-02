// To parse this JSON data, do
//
//     final note = noteFromMap(jsonString);

import 'dart:convert';

class Note {
  Note({
    this.nid,
    this.title = '',
    this.description,
    this.isFavourite = false,
    this.date,
    this.categoryId,
    this.reminderTime,
    this.status,
    this.createionDate,
    this.position,
    this.uid,
    this.hasTime,
    this.deletedDate,
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
  bool? hasTime;
  DateTime? deletedDate;

  factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        nid: map["nid"],
        title: map["title"],
        description: map["description"],
        isFavourite: map["isFavourite"],
        date: map["date"] != null ? DateTime.parse(map["date"]) : null,
        categoryId: map["categoryId"],
        reminderTime: map["reminderTime"],
        status: map["status"],
        position: map["position"],
        createionDate: DateTime.parse(map["createionDate"]),
        uid: map["uid"],
        hasTime: map["hasTime"],
        deletedDate: map["deletedDate"] != null
            ? DateTime.parse(map["deletedDate"])
            : null,
      );

  factory Note.fromMapWithId(Map<String, dynamic> map, String id) {
    final note = Note.fromMap(map);
    note.nid = id;
    return note;
  }

  Map<String, dynamic> toMap() => {
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
        "hasTime": hasTime,
        "deletedDate": deletedDate?.toIso8601String(),
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