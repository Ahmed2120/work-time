import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/models/penalty.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';
import 'package:work_time/data/repositories/i_penalty_repository.dart';
import 'package:work_time/data/repositories/i_user_repository.dart';

class WorkerMonthlyReport {
  final int userId;
  final String userName;
  final String userJob;
  final double dailyRate;
  final double daysPresent;
  final int daysAbsent;
  final int overtimeDays;
  final double totalEarned;
  final double totalReceived;
  final double totalPenalties;
  final double remaining;

  WorkerMonthlyReport({
    required this.userId,
    required this.userName,
    required this.userJob,
    required this.dailyRate,
    required this.daysPresent,
    required this.daysAbsent,
    required this.overtimeDays,
    required this.totalEarned,
    required this.totalReceived,
    this.totalPenalties = 0.0,
    required this.remaining,
  });
}

class MonthlyReportSummary {
  final int year;
  final int month;
  final int totalWorkers;
  final double totalDaysPresent;
  final int totalDaysAbsent;
  final int totalOvertimeDays;
  final double totalSalaryEarned;
  final double totalSalaryReceived;
  final double totalPenalties;
  final double totalRemaining;
  final List<WorkerMonthlyReport> workerReports;

  MonthlyReportSummary({
    required this.year,
    required this.month,
    required this.totalWorkers,
    required this.totalDaysPresent,
    required this.totalDaysAbsent,
    required this.totalOvertimeDays,
    required this.totalSalaryEarned,
    required this.totalSalaryReceived,
    this.totalPenalties = 0.0,
    required this.totalRemaining,
    required this.workerReports,
  });
}

class ReportsViewModel with ChangeNotifier {
  final IUserRepository userRepository;
  final IAttendanceRepository attendanceRepository;
  final IPenaltyRepository penaltyRepository;

  ReportsViewModel({
    IUserRepository? userRepo,
    IAttendanceRepository? attendRepo,
    IPenaltyRepository? penaltyRepo,
  })  : userRepository = userRepo ?? sl<IUserRepository>(),
        attendanceRepository = attendRepo ?? sl<IAttendanceRepository>(),
        penaltyRepository = penaltyRepo ?? sl<IPenaltyRepository>();

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime get selectedMonth => _selectedMonth;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MonthlyReportSummary? _reportSummary;
  MonthlyReportSummary? get reportSummary => _reportSummary;

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    fetchMonthlyReport();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    fetchMonthlyReport();
  }

  void setMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    fetchMonthlyReport();
  }

  Future<void> fetchMonthlyReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<User> allUsers = await userRepository.retrieve();
      final List<Attendance> allAttendance = await attendanceRepository.retrieve();
      final List<Penalty> allPenalties = await penaltyRepository.retrieve();

      final String monthFilter =
          '${_selectedMonth.year}-${_selectedMonth.month < 10 ? '0${_selectedMonth.month}' : '${_selectedMonth.month}'}';

      final List<WorkerMonthlyReport> workerReports = [];

      double grandPresent = 0;
      int grandAbsent = 0;
      int grandOvertime = 0;
      double grandEarned = 0;
      double grandReceived = 0;
      double grandPenalties = 0;

      for (var user in allUsers) {
        // Find attendance for this user in selected month
        final userMonthAttendance = allAttendance.where((a) {
          return a.userId == user.id && a.todayDate.contains(monthFilter);
        }).toList();

        final userMonthPenalties = allPenalties.where((p) {
          return p.userId == user.id && p.date.contains(monthFilter);
        }).toList();

        double presentCount = 0;
        int absentCount = 0;
        int overtimeCount = 0;
        double userEarned = 0;
        double userReceived = 0;
        double userPenalties = userMonthPenalties.fold(0.0, (sum, p) => sum + p.amount);

        for (var att in userMonthAttendance) {
          if (att.status == 1) {
            presentCount += att.dayRatio;
            userEarned += double.tryParse(att.salary) ?? (double.tryParse(user.salary) ?? 0);
          } else {
            absentCount++;
          }

          if (att.overTimeStatus == 1) {
            overtimeCount++;
          }

          userReceived += double.tryParse(att.salaryReceived) ?? 0;
        }

        final double remaining = userEarned - userReceived - userPenalties;

        // Add if worker has attendance or penalties or is an active worker
        if (userMonthAttendance.isNotEmpty || userMonthPenalties.isNotEmpty || user.isDeleted == 0) {
          workerReports.add(
            WorkerMonthlyReport(
              userId: user.id ?? 0,
              userName: user.name,
              userJob: user.job,
              dailyRate: double.tryParse(user.salary) ?? 0,
              daysPresent: presentCount,
              daysAbsent: absentCount,
              overtimeDays: overtimeCount,
              totalEarned: userEarned,
              totalReceived: userReceived,
              totalPenalties: userPenalties,
              remaining: remaining,
            ),
          );

          grandPresent += presentCount;
          grandAbsent += absentCount;
          grandOvertime += overtimeCount;
          grandEarned += userEarned;
          grandReceived += userReceived;
          grandPenalties += userPenalties;
        }
      }

      _reportSummary = MonthlyReportSummary(
        year: _selectedMonth.year,
        month: _selectedMonth.month,
        totalWorkers: workerReports.length,
        totalDaysPresent: grandPresent,
        totalDaysAbsent: grandAbsent,
        totalOvertimeDays: grandOvertime,
        totalSalaryEarned: grandEarned,
        totalSalaryReceived: grandReceived,
        totalPenalties: grandPenalties,
        totalRemaining: grandEarned - grandReceived - grandPenalties,
        workerReports: workerReports,
      );
    } catch (e) {
      debugPrint("Error fetching monthly report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculates and returns the monthly report for a specific worker.
  /// If cached in [reportSummary], it returns immediately without DB roundtrips.
  Future<WorkerMonthlyReport> getWorkerReport({
    required User user,
    DateTime? month,
  }) async {
    final targetMonth = month ?? _selectedMonth;

    // Check in-memory reportSummary first
    if (_reportSummary != null &&
        _reportSummary!.year == targetMonth.year &&
        _reportSummary!.month == targetMonth.month) {
      final cached = _reportSummary!.workerReports
          .where((w) => w.userId == user.id)
          .firstOrNull;
      if (cached != null) return cached;
    }

    final String monthFilter =
        '${targetMonth.year}-${targetMonth.month < 10 ? '0${targetMonth.month}' : '${targetMonth.month}'}';

    final double dailyRate = double.tryParse(user.salary) ?? 0;
    if (user.id == null) {
      return WorkerMonthlyReport(
        userId: 0,
        userName: user.name,
        userJob: user.job,
        dailyRate: dailyRate,
        daysPresent: 0,
        daysAbsent: 0,
        overtimeDays: 0,
        totalEarned: 0,
        totalReceived: 0,
        remaining: 0,
      );
    }

    final List<Attendance> allAttendance =
        await attendanceRepository.retrieveByUserId(user.id!);
    final userMonthAttendance =
        allAttendance.where((a) => a.todayDate.contains(monthFilter)).toList();

    final List<Penalty> allUserPenalties =
        await penaltyRepository.retrieveByUserId(user.id!);
    final userMonthPenalties =
        allUserPenalties.where((p) => p.date.contains(monthFilter)).toList();
    final double userPenalties =
        userMonthPenalties.fold(0.0, (sum, p) => sum + p.amount);

    double presentCount = 0;
    int absentCount = 0;
    int overtimeCount = 0;
    double userEarned = 0;
    double userReceived = 0;

    for (var att in userMonthAttendance) {
      if (att.status == 1) {
        presentCount += att.dayRatio;
        userEarned += double.tryParse(att.salary) ?? dailyRate;
      } else {
        absentCount++;
      }

      if (att.overTimeStatus == 1) {
        overtimeCount++;
      }

      userReceived += double.tryParse(att.salaryReceived) ?? 0;
    }

    final double remaining = userEarned - userReceived - userPenalties;

    return WorkerMonthlyReport(
      userId: user.id!,
      userName: user.name,
      userJob: user.job,
      dailyRate: dailyRate,
      daysPresent: presentCount,
      daysAbsent: absentCount,
      overtimeDays: overtimeCount,
      totalEarned: userEarned,
      totalReceived: userReceived,
      totalPenalties: userPenalties,
      remaining: remaining,
    );
  }
}
