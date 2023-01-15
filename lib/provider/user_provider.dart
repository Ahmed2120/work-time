import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';
import 'package:work_time/provider/attendance_provider.dart';

import '../db/userRepository.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
    List<User> _users = [];

   List<User> _usersTrash = [];

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
    _users=await userRepository.retrieve();
    notifyListeners();
  }
    List<User> searchUsers(String txt) {
      List<User> usersListSearch = [];
      if (_users.isNotEmpty) {
        for (var element in _users) {
          if (element.name.contains(txt) || element.job.contains(txt)) {
            usersListSearch.add(element);
          }
        }
      }
      _users = usersListSearch;
      notifyListeners();
      return _users;
    }

    bool clickSearch=false;
  void changeClickSearch(){
    clickSearch=!clickSearch;
    notifyListeners();
  }

    getTrash()async{
      final userRepository = UserRepository();
      _usersTrash=await userRepository.retrieve(trash: 1);
      notifyListeners();
    }

  updateUser(User user){
    final userRepository = UserRepository();
    userRepository.update(user: user);
    getUsers();
    getTrash();
    notifyListeners();
  }
deleteUser(User user){
  final userRepository = UserRepository();
  final attendanceRepository = AttendanceRepository();

  attendanceRepository.deleteByUserId(user.id!);
  userRepository.delete(user);
  getUsers();
  getTrash();
  notifyListeners();
}
  void filteringUser(String value) {
    if (value == 'الكل') {
      _filteredUsers = _users;
    } else {
      _filteredUsers =
          _users.where((user) => double.parse(value) == user.salary).toList();
    }
    print(filteredUsers);
    notifyListeners();
  }
}
