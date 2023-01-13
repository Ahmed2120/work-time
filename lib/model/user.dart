import 'package:flutter/material.dart';

class User with ChangeNotifier{
  int? id;
  final String name;
  final String job;
  final String salary;
  int isDeleted;


  User(
      { this.id,
        required this.name,
        required this.job,
        required this.salary,
        this.isDeleted=0
      });

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        job = res["job"],
        salary = res["salary"],
        isDeleted=res['isDeleted'];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name, 'job': job, 'salary': salary,'isDeleted':isDeleted};
  }
}
