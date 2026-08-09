import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';
import 'package:work_time/data/repositories/i_user_repository.dart';

class UserViewModel with ChangeNotifier {
  final IUserRepository userRepository;
  final IAttendanceRepository attendanceRepository;

  UserViewModel({
    IUserRepository? userRepository,
    IAttendanceRepository? attendanceRepository,
  })  : userRepository = userRepository ?? sl<IUserRepository>(),
        attendanceRepository = attendanceRepository ?? sl<IAttendanceRepository>();

  List<User> _users = [];
  List<User> _usersTrash = [];
  List<String> _filteredUsers = [];
  User _user = User(name: '', job: '', salary: '');

  List<User> get users => _users;
  List<User> get usersTrash => _usersTrash;
  List<String> get filteredUsers => _filteredUsers;
  User get user => _user;

  void setUser(User val) {
    _user = val;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    final int userId = await userRepository.insert(user);
    user.id = userId;
    _users.add(user);
    getSalaries();
    notifyListeners();
  }

  Future getUsers() async {
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
    _usersTrash = await userRepository.retrieve(trash: 1);
    notifyListeners();
  }

  updateUser(User user) async {
    await userRepository.update(user: user);
    getUsers();
    getTrash();
    getSalaries();
    notifyListeners();
  }

  deleteUser(User user) async {
    await attendanceRepository.deleteByUserId(user.id!);
    await userRepository.delete(user);
    getUsers();
    getTrash();
    getSalaries();
    notifyListeners();
  }

  getSalaries() async {
    List<String> list = [];
    _filteredUsers = [];
    _filteredUsers.add('الكل');
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

  // ─── Status Filter (الكل, حاضر, غائب, لم يسجل) ─────────────────────────────
  String _statusFilter = 'الكل';
  String get statusFilter => _statusFilter;

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }
}
