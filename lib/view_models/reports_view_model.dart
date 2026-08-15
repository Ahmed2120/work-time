import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';
import 'package:work_time/data/repositories/i_user_repository.dart';

class WorkerMonthlyReport {
  final int userId;
  final String userName;
  final String userJob;
  final double dailyRate;
  final int daysPresent;
  final int daysAbsent;
  final int overtimeDays;
  final double totalEarned;
  final double totalReceived;
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
    required this.remaining,
  });
}

class MonthlyReportSummary {
  final int year;
  final int month;
  final int totalWorkers;
  final int totalDaysPresent;
  final int totalDaysAbsent;
  final int totalOvertimeDays;
  final double totalSalaryEarned;
  final double totalSalaryReceived;
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
    required this.totalRemaining,
    required this.workerReports,
  });
}

class ReportsViewModel with ChangeNotifier {
  final IUserRepository userRepository;
  final IAttendanceRepository attendanceRepository;

  ReportsViewModel({
    IUserRepository? userRepo,
    IAttendanceRepository? attendRepo,
  })  : userRepository = userRepo ?? sl<IUserRepository>(),
        attendanceRepository = attendRepo ?? sl<IAttendanceRepository>();

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

      final String monthFilter =
          '${_selectedMonth.year}-${_selectedMonth.month < 10 ? '0${_selectedMonth.month}' : '${_selectedMonth.month}'}';

      final List<WorkerMonthlyReport> workerReports = [];

      int grandPresent = 0;
      int grandAbsent = 0;
      int grandOvertime = 0;
      double grandEarned = 0;
      double grandReceived = 0;

      for (var user in allUsers) {
        // Find attendance for this user in selected month
        final userMonthAttendance = allAttendance.where((a) {
          return a.userId == user.id && a.todayDate.contains(monthFilter);
        }).toList();

        int presentCount = 0;
        int absentCount = 0;
        int overtimeCount = 0;
        double userEarned = 0;
        double userReceived = 0;

        for (var att in userMonthAttendance) {
          if (att.status == 1) {
            presentCount++;
            userEarned += double.tryParse(att.salary) ?? (double.tryParse(user.salary) ?? 0);
          } else {
            absentCount++;
          }

          if (att.overTimeStatus == 1) {
            overtimeCount++;
          }

          userReceived += double.tryParse(att.salaryReceived) ?? 0;
        }

        final double remaining = userEarned - userReceived;

        // Add if worker has attendance or is an active worker
        if (userMonthAttendance.isNotEmpty || user.isDeleted == 0) {
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
              remaining: remaining,
            ),
          );

          grandPresent += presentCount;
          grandAbsent += absentCount;
          grandOvertime += overtimeCount;
          grandEarned += userEarned;
          grandReceived += userReceived;
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
        totalRemaining: grandEarned - grandReceived,
        workerReports: workerReports,
      );
    } catch (e) {
      debugPrint("Error fetching monthly report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
