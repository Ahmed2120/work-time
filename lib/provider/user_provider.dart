import 'package:flutter/material.dart';

import '../db/userRepository.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
    List<User> _users = [];

  final List<User> _usersTrash = [];

  List<User> get users {
    return _users;
  }

  List<User> get usersTrash {
    return _usersTrash;
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

   getUsers()async{
    final userRepository = UserRepository();
    print(DateTime.now());
    _users=await userRepository.retrieve();
    notifyListeners();
  }

  updateUser(User user){
    final userRepository = UserRepository();
    userRepository.update(user: user);
    getUsers();
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
