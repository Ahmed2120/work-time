import 'package:work_time/data/models/attendance.dart';

final Map<int, List<Attendance>> fakeWeekAttendanceMap = {
  // ─── الأسبوع 1: الفترة (15-08-2026 إلى 21-08-2026) - قيد العمل (weekStatus = 0) ───
  1: [
    Attendance(
      id: 1,
      userId: 1,
      todayDate: '2026-08-15',
      weekEnd: '2026-08-21',
      weekId: 1,
      weekStatus: 0, // مفتوح (غير مصفى)
      status: 1,     // حاضر
      overTimeStatus: 0,
      salary: '150.0',
      salaryReceived: '50.0',
      workPlace: 'موقع الرياض - فيلا 12',
    ),
    Attendance(
      id: 2,
      userId: 1,
      todayDate: '2026-08-16',
      weekEnd: '2026-08-21',
      weekId: 1,
      weekStatus: 0,
      status: 1,     // حاضر
      overTimeStatus: 1, // سهرة
      salary: '150.0',
      salaryReceived: '0.0',
      workPlace: 'موقع الرياض - فيلا 12',
    ),
    Attendance(
      id: 3,
      userId: 1,
      todayDate: '2026-08-17',
      weekEnd: '2026-08-21',
      weekId: 1,
      weekStatus: 0,
      status: 0,     // غائب
      overTimeStatus: 0,
      salary: '0.0',
      salaryReceived: '0.0',
      workPlace: '—',
    ),
    Attendance(
      id: 4,
      userId: 1,
      todayDate: '2026-08-18',
      weekEnd: '2026-08-21',
      weekId: 1,
      weekStatus: 0,
      status: 1,     // حاضر
      overTimeStatus: 0,
      salary: '150.0',
      salaryReceived: '100.0',
      workPlace: 'ورشة النجارة الرئيسية',
    ),
  ],

  // ─── الأسبوع 2: الفترة (08-08-2026 إلى 14-08-2026) - مصفى حسابه (weekStatus = 1) ───
  2: [
    Attendance(
      id: 5,
      userId: 1,
      todayDate: '2026-08-08',
      weekEnd: '2026-08-14',
      weekId: 2,
      weekStatus: 1, // مصفى حسابه
      status: 1,
      overTimeStatus: 0,
      salary: '150.0',
      salaryReceived: '150.0',
      workPlace: 'مشروع العليا',
    ),
    Attendance(
      id: 6,
      userId: 1,
      todayDate: '2026-08-09',
      weekEnd: '2026-08-14',
      weekId: 2,
      weekStatus: 1,
      status: 1,
      overTimeStatus: 1,
      salary: '150.0',
      salaryReceived: '0.0',
      workPlace: 'مشروع العليا',
    ),
    Attendance(
      id: 7,
      userId: 1,
      todayDate: '2026-08-10',
      weekEnd: '2026-08-14',
      weekId: 2,
      weekStatus: 1,
      status: 1,
      overTimeStatus: 0,
      salary: '150.0',
      salaryReceived: '150.0',
      workPlace: 'مشروع العليا',
    ),
  ],
};
