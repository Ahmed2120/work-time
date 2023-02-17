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

  List<String> _filteredUsers = [];

  List<String> get filteredUsers {
    return _filteredUsers;
  }

  Future<void> addUser(User user) async {
    final userRepository = UserRepository();

    final int userId = await userRepository.insert(user);
    user.id = userId;
    _users.add(user);
    getSalaries();
    notifyListeners();
  }

  Future getUsers() async {
    final userRepository = UserRepository();
    _users = await userRepository.retrieve();
    getTrash();
    getSalaries();
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
      _users = usersListSearch;
      notifyListeners();
    } else {
      getUsers();
    }
    return _users;
  }

  bool clickSearch = false;

  void changeClickSearch() {
    clickSearch = !clickSearch;
    notifyListeners();
  }

  getTrash() async {
    final userRepository = UserRepository();
    _usersTrash = await userRepository.retrieve(trash: 1);
    notifyListeners();
  }

  updateUser(User user) {
    final userRepository = UserRepository();
    userRepository.update(user: user);
    getUsers();
    getTrash();
    getSalaries();
    notifyListeners();
  }

  deleteUser(User user) {
    final userRepository = UserRepository();
    final attendanceRepository = AttendanceRepository();

    attendanceRepository.deleteByUserId(user.id!);
    userRepository.delete(user);
    getUsers();
    getTrash();
    getSalaries();
    notifyListeners();
  }

  getSalaries() async {
    List<String> list = [];
    _filteredUsers = [];
    _filteredUsers.add('الكل');
    final userRepository = UserRepository();
    list = await userRepository.retrieveSalaries();
    _filteredUsers.addAll(list);
    notifyListeners();
  }

  String dropDownValue = 'الكل';

  dropDownChane(String val) {
    dropDownValue = val;
    filteringUser(dropDownValue);
    notifyListeners();
  }

  List<User> filteringUser(String txt) {
    if (txt == 'الكل') {
      getUsers();
    } else {
      _users = _users.where((user) => txt == user.salary).toList();
    }
    notifyListeners();
    return _users;
  }
}
