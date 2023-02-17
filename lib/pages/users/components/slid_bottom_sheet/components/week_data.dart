import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/users/components/slid_bottom_sheet/components/week_status.dart';

import '../../../../../provider/attendance_provider.dart';
import '../table/table.dart';

class WeekData extends StatelessWidget {
  const WeekData({required this.index,Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {

    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final weeksList = attendanceProvider.weeksList;

    return  Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: ExpansionTile(
        title: Row(children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFF533483),
            child: Text('${index+1}',style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 10),
          Text('الاسبوع '),
          SizedBox(width: 10),
          Text('${DateTime.parse(attendanceProvider
              .weekAttendanceMap[weeksList[index]]![0].weekEnd).year}- ${DateTime.parse(attendanceProvider
              .weekAttendanceMap[weeksList[index]]![0].weekEnd).month}'),
        ],),
        childrenPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          InteractiveViewer(
            child:TableData(week:attendanceProvider
                .weekAttendanceMap[weeksList[index]],) ,
          ),
          const SizedBox(height: 20),
          Text(
              'المبلغ الكلي : ${attendanceProvider.totalSalary(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}'),
          Text(
              'المبلغ المدفوع : ${attendanceProvider.sumSalaryReceived(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}'),
          Text(
              "المبلغ المتبقي : ${attendanceProvider.totalSalary(attendanceProvider.weekAttendanceMap[weeksList[index]]!)-attendanceProvider.sumSalaryReceived(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}"),
          const SizedBox(height: 10),
          WeekStatus(index: index, weeks: weeksList[index],)
        ],
      ),
    );
  }
}
