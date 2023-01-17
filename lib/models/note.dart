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
    this.reminderTime = 0,
    this.status,
    this.createionDate = 0,
    this.position,
    this.uid,
    this.hasTime = false,
    this.subTasks = const [],
  });

  String? nid;
  String title;
  String? description;
  bool isFavourite;
  DateTime? date;
  String? categoryId;
  int reminderTime;
  int? status;
  int createionDate;
  double? position;
  String? uid;
  bool hasTime;
  List<SubTask?> subTasks;

  factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        nid: map["nid"],
        title: map["title"],
        description: map["description"],
        isFavourite: map["isFavourite"],
        date: map["date"] != null ? DateTime.parse(map["date"]) : null,
        categoryId: map["categoryId"],
        reminderTime: map["reminderTime"] ?? 0,
        status: map["status"],
        createionDate: map["createionDate"] ?? 0,
        position: map["position"]?.toDouble(),
        uid: map["uid"],
        hasTime: map["hasTime"] ?? false,
        subTasks: map["subTasks"] == null
            ? []
            : List<SubTask?>.from(
                map["subTasks"]!.map((x) => SubTask.fromJson(x))),
      );

  factory Note.clone(Note note) => Note(
      nid: note.nid,
      title: note.title,
      description: note.description,
      isFavourite: note.isFavourite,
      date: note.date,
      categoryId: note.categoryId,
      reminderTime: note.reminderTime,
      status: note.status,
      position: note.position,
      uid: note.uid,
      hasTime: note.hasTime,
      subTasks:
          note.subTasks.map((subTask) => SubTask.clone(subTask!)).toList());

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
        "createionDate": createionDate,
        "position": position,
        "uid": uid,
        "hasTime": hasTime,
        "subTasks": subTasks == null
            ? []
            : List<dynamic>.from(subTasks!.map((x) => x!.toJson())),
      };
}

class SubTask {
  SubTask({
    this.title = '',
    this.checked = false,
  });

  String title;
  bool checked;

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        title: json["title"],
        checked: json["checked"],
      );

  factory SubTask.clone(SubTask subTask) => SubTask(
        title: subTask.title,
        checked: subTask.checked,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "checked": checked,
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
    "createionDate":"1944-06-06 02:00:00.000",
    "position":1,
    "uid":"dasdasdasdas",
    "hasTime":true,
    "subTasks":[{"title":"t1","checked":true},{"title":"t2","checked":false}]
}
 */