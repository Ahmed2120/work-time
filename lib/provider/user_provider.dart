import 'package:flutter/material.dart';

import '../model/user.dart';

class UserProvider with ChangeNotifier{
  List<User> _users = [
    User(name: 'أحمد', status: 'حاضر', salary: 100),
    User(name: 'محمد', status: 'غائب', salary: 200),
    User(name: 'سعيد', status: 'غائب', salary: 200),
    User(name: 'أسامة', status: 'حاضر', salary: 100),
    User(name: 'محمود', status: 'غائب', salary: 300),
  ];

  List<User> get users{
    return _users;
  }

  List<User> _filteredUsers = [];

  List<User> get filteredUsers{
    return _filteredUsers;
  }

  void filteringUser(String value){
    if(value == 'الكل'){
      _filteredUsers = _users;
    }
    else{
      _filteredUsers = _users.where((user) => double.parse(value) == user.salary).toList();
    }
    notifyListeners();
  }
}