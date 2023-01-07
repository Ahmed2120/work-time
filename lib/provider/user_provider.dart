import 'package:flutter/material.dart';

import '../db/userRepository.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [
    User(name: 'أحمد', job: 'حاضر', salary: 100),
    User(name: 'محمد', job: 'غائب', salary: 200),
    User(name: 'سعيد', job: 'غائب', salary: 200),
    User(name: 'أسامة', job: 'حاضر', salary: 100),
    User(name: 'محمود', job: 'غائب', salary: 300),
  ];

  List<User> get users {
    return _users;
  }

  late User _userModel;

  User get userModel {
    return _userModel;
  }

  getUser(int id) {
    _userModel = _users.firstWhere((element) => element.id == id);
    notifyListeners();
  }

  List<User> _filteredUsers = [];

  List<User> get filteredUsers {
    return _filteredUsers;
  }

  Future<void> addUser(User user) async {
    final userRepository = UserRepository();

    final int userId = await userRepository.insert(user);
    user.id = userId;
    _users.add(user);

    notifyListeners();
  }

  void filteringUser(String value) {
    if (value == 'الكل') {
      _filteredUsers = _users;
    } else {
      _filteredUsers =
          _users.where((user) => double.parse(value) == user.salary).toList();
    }
    notifyListeners();
  }
}
