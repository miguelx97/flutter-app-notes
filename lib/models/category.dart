import 'dart:convert';

class Category {
  Category({
    this.id,
    required this.title,
    required this.emoji,
  });

  String? id;
  String title;
  String emoji;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        emoji: json["emoji"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "emoji": emoji,
      };
}


/**
{
    "id":"1",
    "title":"dentista",
    "emoji":"ir al dentista"
}
 */