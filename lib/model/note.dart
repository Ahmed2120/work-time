import 'package:flutter/material.dart';

class Note with ChangeNotifier{
  int? id;
  final String title;
  final String description;
  final String dateCreated;
  final int color;
  Note(
      { this.id,
        required this.title,
        required this.description,
        required this.dateCreated,
        required this.color
      });
  Note.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
  color = res['color'],
        dateCreated = res["dateCreated"];
  Map<String, Object?> toMap() {
    return {'id':id,'title': title,'color':color, 'description': description, 'dateCreated': dateCreated};
  }
}
