import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/core/utils/global_methods.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';

class AttendanceViewModel with ChangeNotifier {
  final IAttendanceRepository attendanceRepository;

  AttendanceViewModel({IAttendanceRepository? repository})
      : attendanceRepository = repository ?? sl<IAttendanceRepository>();

  final List<Attendance> _attendanceList = [];
  List<Attendance> get attendanceList => _attendanceList;

  Future<void> addAttendance(Attendance attendance) async {
    await attendanceRepository.insert(attendance);
    _attendanceList.add(attendance);
    invalidateTodayCache(); // ← الـ cache بيتبطل بعد أي إضافة
    notifyListeners();
  }

  List<Attendance> _attendanceModel = [];
  List<Attendance> get attendanceModel => _attendanceModel;

  String date = '';
  String time = '';
  String attendanceText = 'غائب';

  Future getAttendanceUserToDay({required int userId}) async {
    _attendanceModel = await attendanceRepository.retrieveByUserIdDateTime(userId, dateTimeAttendance);
    if (attendanceModel.isNotEmpty) {
      DateTime dateTime = DateTime.parse(attendanceModel.last.todayDate);
      date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      time = GlobalMethods.getTimeFormat(DateTime.parse(attendanceModel.last.todayDate));
      if (attendanceModel.last.status == 1) {
        attendanceText = 'حاضر';
      } else {
        attendanceText = 'غائب';
      }
    } else {
      attendanceText = 'لم يسجل';
    }
    notifyListeners();
  }

  DateTime dateTimeAttendance = DateTime.now();

  void changeDate(DateTime? dateTime) {
    if (dateTime == null) return;
    dateTimeAttendance = dateTime;
    invalidateTodayCache(); // ← بطّل الـ cache لما التاريخ يتغير
    notifyListeners();
  }

  Future<Attendance?> getAttendByUserAndDate({required int userId}) async {
    final List<Attendance> attend =
        await attendanceRepository.retrieveByUserIdDateTime(userId, dateTimeAttendance);
    if (attend.isEmpty) return null;
    return attend.last;
  }

  // ─── Today Attendance Map Cache (Problem 2) ──────────────────────────────
  // DB call واحدة لكل الـ users بدل N calls داخل الـ ListView
  Map<int, Attendance?>? _todayAttendanceMap;

  /// يجيب حضور كل الـ users في DB call واحدة ويخزّنهم في Map.
  /// بيُستدعى مرة واحدة — الـ ListView بيقرأ منه بـ O(1).
  Future<void> preloadTodayAttendance(List<int> userIds) async {
    if (_todayAttendanceMap != null) return; // already loaded

    final allToday = await attendanceRepository.retrieveByDate(dateTimeAttendance);

    final map = <int, Attendance?>{};
    for (var a in allToday) {
      map[a.userId] = a; // آخر record لو فيه تكرار
    }
    for (final id in userIds) {
      map.putIfAbsent(id, () => null); // مش موجود = null = لم يسجل
    }
    _todayAttendanceMap = map;
    notifyListeners();
  }

  /// O(1) lookup من الـ cache — بدون DB call.
  Attendance? getAttendanceFromCache(int userId) => _todayAttendanceMap?[userId];

  /// بيبطّل الـ cache — بيُستدعى بعد أي add أو update.
  void invalidateTodayCache() {
    _todayAttendanceMap = null;
    _dailySummaryCache = null;
    _summaryCacheDate = null;
  }

  // ─── Daily Summary Cache (Problem 1) ─────────────────────────────────────
  // بيخزّن عدد الحاضرين/الغائبين/غير المسجلين — بيُحسب مرة في اليوم
  Map<String, int>? _dailySummaryCache;
  DateTime? _summaryCacheDate;

  /// يرجع {present, absent, pending} للـ users المُمررة.
  /// محسوبة مرة واحدة في اليوم من الـ today-map — zero extra DB calls.
  Future<Map<String, int>> getDailySummary(List<int> userIds) async {
    final today = dateTimeAttendance;

    // ✅ Cache hit — مفيش DB calls
    if (_dailySummaryCache != null &&
        _summaryCacheDate?.day == today.day &&
        _summaryCacheDate?.month == today.month &&
        _summaryCacheDate?.year == today.year) {
      return _dailySummaryCache!;
    }

    await preloadTodayAttendance(userIds); // ضمان إن الـ map محمّلة

    int present = 0, absent = 0, pending = 0;
    for (final id in userIds) {
      final a = _todayAttendanceMap?[id];
      if (a == null) {
        pending++;
      } else if (a.status == 1) {
        present++;
      } else {
        absent++;
      }
    }

    _dailySummaryCache = {'present': present, 'absent': absent, 'pending': pending};
    _summaryCacheDate = today;
    return _dailySummaryCache!;
  }

  Future<void> updateAttendance({required Attendance attendance}) async {
    await attendanceRepository.update(attendance: attendance);
    invalidateTodayCache(); // ← بطّل الـ cache بعد الـ update
    notifyListeners();
  }

  // AttendanceList for each user
  List<Attendance> _attendanceUser = [];
  List<Attendance> get attendanceUser => _attendanceUser;

  Future getAttendanceUser(int userId) async {
    _attendanceUser = await attendanceRepository.retrieveByUserId(userId);
    notifyListeners();
  }

  Future<int> setWeekId({required int userId, DateTime? date}) async {
    final list = await attendanceRepository.retrieveByUserId(userId);
    _attendanceUser = list;

    final DateTime targetDate = date ?? dateTimeAttendance;
    final DateTime targetWeekEnd = GlobalMethods.getWeekEnd(targetDate);

    // Reuse the active (unsettled) week whose weekEnd falls in the same calendar week
    for (var element in _attendanceUser) {
      if (element.weekStatus == 0) {
        final DateTime? stored = DateTime.tryParse(element.weekEnd);
        if (stored != null &&
            stored.year == targetWeekEnd.year &&
            stored.month == targetWeekEnd.month &&
            stored.day == targetWeekEnd.day) {
          return element.weekId;
        }
      }
    }

    // New week period — assign new weekId
    int maxWeekId = 0;
    for (var element in _attendanceUser) {
      if (element.weekId > maxWeekId) maxWeekId = element.weekId;
    }
    return maxWeekId + 1;
  }

  // ─── Weeks list ───────────────────────────────────────────────────────────
  List<int> _weeksList = [];
  List<int> get weeksList => _weeksList;

  Future getWeeks(int userId) async {
    _weeksList = await attendanceRepository.retrieveWeeks(userId);
    await getWeeklyAttendance(userId);
    notifyListeners();
  }

  List<Attendance> _weeklyAttendance = [];
  List<Attendance> get weeklyAttendance => _weeklyAttendance;

  Future getWeeklyAttendance(int userId) async {
    _weeklyAttendance = await attendanceRepository.retrieveByUserId(userId);
    _buildWeekCache(); // ← بنبني الـ cache هنا بس — مش في كل getter call
    notifyListeners();
  }

  // ─── Week Map Cache (Problem 6) ───────────────────────────────────────────
  // بدل ما نعمل Map + Sort في كل getter call، بنحسبهم مرة واحدة
  Map<int, List<Attendance>>? _cachedWeekMap;
  List<List<Attendance>>? _cachedSortedGroups;

  /// بيبني weekAttendanceMap و sortedWeekGroups مرة واحدة بعد تحميل البيانات.
  void _buildWeekCache() {
    final map = <int, List<Attendance>>{};
    for (var a in _weeklyAttendance) {
      map.putIfAbsent(a.weekId, () => []).add(a);
    }
    // Sort days inside each week ascending
    for (final key in map.keys) {
      map[key]!.sort((a, b) {
        final da = DateTime.tryParse(a.todayDate) ?? DateTime.now();
        final db = DateTime.tryParse(b.todayDate) ?? DateTime.now();
        return da.compareTo(db);
      });
    }
    _cachedWeekMap = map;

    // Sort week groups by their end date (oldest first)
    final groups = map.values.toList();
    groups.sort((a, b) {
      final da = DateTime.tryParse(a.first.weekEnd) ?? DateTime.now();
      final db = DateTime.tryParse(b.first.weekEnd) ?? DateTime.now();
      return da.compareTo(db);
    });
    _cachedSortedGroups = groups;
  }

  /// Grouped by weekId, days sorted by date ascending. Computed once, cached.
  Map<int, List<Attendance>> get weekAttendanceMap => _cachedWeekMap ?? {};

  /// Week groups sorted chronologically (oldest first). Computed once, cached.
  List<List<Attendance>> get sortedWeekGroups => _cachedSortedGroups ?? [];

  // Calculates total salary for a week group
  double totalSalary(List<Attendance> weekGroup) {
    double total = 0;
    for (var attend in weekGroup) {
      total += double.tryParse(attend.salary) ?? 0;
    }
    return total;
  }

  // Calculates total salary received (drawn) for a week group
  double sumSalaryReceived(List<Attendance> weekGroup) {
    double total = 0;
    for (var attend in weekGroup) {
      total += double.tryParse(attend.salaryReceived) ?? 0;
    }
    return total;
  }

  int _checkBoxVal = 0;
  int get checkBoxVal => _checkBoxVal;

  void changeCheckBox(bool val) {
    _checkBoxVal = val ? 1 : 0;
    notifyListeners();
  }

  List<String> _previousWorkPlaces = [];
  List<String> get previousWorkPlaces => _previousWorkPlaces;

  Future<void> getWorkPlaces() async {
    _previousWorkPlaces = await attendanceRepository.retrieveWorkPlaces();
    notifyListeners();
  }
}
