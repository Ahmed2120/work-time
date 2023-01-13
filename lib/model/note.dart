import 'package:flutter/material.dart';

class Note with ChangeNotifier{
  int? id;
  final String title;
  final String description;
  final String dateCreated;
  Note(
      { this.id,
        required this.title,
        required this.description,
        required this.dateCreated,
      });
  Note.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        dateCreated = res["dateCreated"];
  Map<String, Object?> toMap() {
    return {'id':id,'title': title, 'description': description, 'dateCreated': dateCreated};
  }
}
