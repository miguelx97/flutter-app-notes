import 'dart:convert';

class Category {
  Category({
    this.cid,
    required this.title,
    required this.emoji,
    this.position,
    this.uid,
  });

  String? cid;
  String title;
  String emoji;
  double? position;
  String? uid;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMapWithId());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        cid: json["cid"],
        title: json["title"],
        emoji: json["emoji"],
        position: json["position"]?.toDouble(),
        uid: json["uid"],
      );

  factory Category.fromObject(Category oldCategory) => Category(
      cid: oldCategory.cid,
      title: oldCategory.title,
      emoji: oldCategory.emoji,
      uid: oldCategory.uid,
      position: oldCategory.position);

  Map<String, dynamic> toMapWithId() {
    final map = toMap();
    map['cid'] = cid;
    return map;
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "emoji": emoji,
        "position": position,
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
    "position":1.1,
    "createionDate":"1944-06-06 02:00:00.000",
    "uid":"dasdasdasdas",
    "hasTime":true,
    "deletedDate":"1944-06-06 02:00:00.000"
}
*/