import 'package:flutter/material.dart';

class User with ChangeNotifier{
  int? id;
  final String name;
  final String job;
  final String salary;


  User(
      { this.id,
        required this.name,
        required this.job,
        required this.salary,
      });

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        job = res["job"],
        salary = res["salary"];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name, 'job': job, 'salary': salary};
  }
}
