import 'package:flutter_test/flutter_test.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
// 1. Fake Repository يعطينا بيانات مشوّشة في الترتيب
class FakeAttendanceRepository implements IAttendanceRepository {
  @override
  Future<List<Attendance>> retrieveByUserId(int userId) async {
    return [
      Attendance(id: 1, userId: 1, todayDate: '2026-08-16', weekEnd: '2026-08-21', weekId: 2, weekStatus: 0, status: 1, salary: '100', salaryReceived: '0', workPlace: ''),
      Attendance(id: 2, userId: 1, todayDate: '2026-08-06', weekEnd: '2026-08-07', weekId: 1, weekStatus: 1, status: 1, salary: '100', salaryReceived: '0', workPlace: ''),
      Attendance(id: 3, userId: 1, todayDate: '2026-08-15', weekEnd: '2026-08-21', weekId: 2, weekStatus: 0, status: 1, salary: '100', salaryReceived: '0', workPlace: ''),
      Attendance(id: 4, userId: 1, todayDate: '2026-08-01', weekEnd: '2026-08-07', weekId: 1, weekStatus: 1, status: 1, salary: '100', salaryReceived: '0', workPlace: ''),
    ];
  }
  // باقي دوال الإنترفيس (تترك فارغة لأننا نختبر فقط الأسابيع)
  @override dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main()async{

  test("اختبار ترتيب الاسابيع", ()async{
  final fakeRepo = FakeAttendanceRepository();
  final viewModel = AttendanceViewModel(repository: fakeRepo);

  await viewModel.getWeeklyAttendance(1);

  // viewModel.weekAttendanceMap.forEach((key, val){
  //   print("$key: ");
  //   for(var el in val){
  //     print("${el.toMap()}");
  //   }
  // });
  //
  // print("______________________________");
  // print("______________________________");
  //
  viewModel.sortedWeekGroups.forEach((val){
    // for(var el in val){
      print(val);
    // }
  });

  final sortedWeeks = viewModel.sortedWeekGroups;
  final mapDays = viewModel.weekAttendanceMap;

  expect(sortedWeeks[0].first.todayDate, '2026-08-01');
  expect(sortedWeeks[0].last.weekEnd, '2026-08-07');
  expect(mapDays[1]![0].todayDate, '2026-08-01');
  });
}