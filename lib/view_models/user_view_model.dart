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

  List<User> _allUsers = [];
  List<User> _users = [];
  List<User> _usersTrash = [];
  List<String> _filteredUsers = [];
  List<String> _jobs = ['الكل'];
  User _user = User(name: '', job: '', salary: '');

  List<User> get allUsers => _allUsers;
  List<User> get users => _users;
  List<User> get usersTrash => _usersTrash;
  List<String> get filteredUsers => _filteredUsers; // Salaries list
  List<String> get jobs => _jobs;                   // Jobs list
  User get user => _user;

  bool clickSearch = false;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// True when the search bar is active AND user has entered a search query
  bool get isSearching => clickSearch && _searchQuery.trim().isNotEmpty;

  // ─── Status Filter (الكل, حاضر, غائب, لم يسجل) ─────────────────────────────
  String _statusFilter = 'الكل';
  String get statusFilter => _statusFilter;

  // ─── Salary Filter ─────────────────────────────────────────────────────────
  String dropDownValue = 'الكل';

  // ─── Job Role Filter ───────────────────────────────────────────────────────
  String _selectedJob = 'الكل';
  String get selectedJob => _selectedJob;

  void setUser(User val) {
    _user = val;
    notifyListeners();
  }

  void _applyCombinedFilters() {
    _users = _allUsers.where((u) {
      final matchesSalary = (dropDownValue == 'الكل' || u.salary == dropDownValue);
      final matchesJob = (_selectedJob == 'الكل' || u.job == _selectedJob);
      return matchesSalary && matchesJob;
    }).toList();
  }

  Future<void> addUser(User user) async {
    final int userId = await userRepository.insert(user);
    user.id = userId;
    _allUsers.add(user);
    _applyCombinedFilters();
    _updateSearchResults();
    await getSalaries();
    await getJobs();
    notifyListeners();
  }

  Future<void> getUsers() async {
    _allUsers = await userRepository.retrieve();
    _applyCombinedFilters();
    _updateSearchResults();
    await getTrash();
    await getSalaries();
    await getJobs();
    notifyListeners();
  }

  List<User> _searchResults = [];

  // ─── Search Operations (Searches across ALL users without mutating _users) ──
  void setSearchQuery(String query) {
    _searchQuery = query;
    _updateSearchResults();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _updateSearchResults();
    notifyListeners();
  }

  List<User> searchUsers(String txt) {
    _searchQuery = txt;
    _updateSearchResults();
    notifyListeners();
    return _searchResults;
  }

  void _updateSearchResults() {
    final trimmed = _searchQuery.trim();
    if (trimmed.isEmpty) {
      _searchResults = _allUsers;
      return;
    }
    final query = trimmed.toLowerCase();
    _searchResults = _allUsers.where((element) {
      final nameMatch = element.name.toLowerCase().contains(query);
      final jobMatch = element.job.toLowerCase().contains(query);
      return nameMatch || jobMatch;
    }).toList();
  }

  /// Returns cached filtered list over ALL users based on the active query
  List<User> get searchResults => _searchResults;

  void changeClickSearch() {
    clickSearch = !clickSearch;
    if (!clickSearch) {
      _searchQuery = '';
      _updateSearchResults();
    }
    notifyListeners();
  }

  Future<void> getTrash() async {
    _usersTrash = await userRepository.retrieve(trash: 1);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await userRepository.update(user: user);
    await getUsers();
  }

  Future<void> deleteUser(User user) async {
    await attendanceRepository.deleteByUserId(user.id!);
    await userRepository.delete(user);
    await getUsers();
  }

  Future<void> getSalaries() async {
    final list = await userRepository.retrieveSalaries();
    _filteredUsers = ['الكل', ...list];
    notifyListeners();
  }

  Future<void> getJobs() async {
    final list = await userRepository.retrieveJobs();
    _jobs = ['الكل', ...list];
    notifyListeners();
  }

  void dropDownChane(String val) {
    dropDownValue = val;
    _applyCombinedFilters();
    notifyListeners();
  }

  void setJobFilter(String job) {
    _selectedJob = job;
    _applyCombinedFilters();
    notifyListeners();
  }

  List<User> filteringUser(String txt) {
    dropDownValue = txt;
    _applyCombinedFilters();
    notifyListeners();
    return _users;
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }
}
