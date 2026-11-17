import 'package:flutter/material.dart';

class User with ChangeNotifier {
  int? id;
  String name;
  String job;
  String salary;
  int isDeleted;
  double defaultDayRatio;

  User({
    this.id,
    required this.name,
    required this.job,
    required this.salary,
    this.isDeleted = 0,
    this.defaultDayRatio = 1.0,
  });

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        job = res["job"],
        salary = res["salary"],
        isDeleted = res['isDeleted'] ?? 0,
        defaultDayRatio = (res['defaultDayRatio'] as num?)?.toDouble() ?? 1.0;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'salary': salary,
      'isDeleted': isDeleted,
      'defaultDayRatio': defaultDayRatio,
    };
  }
}






