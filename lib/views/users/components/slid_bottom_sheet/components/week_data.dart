import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/views/users/components/slid_bottom_sheet/components/week_status.dart';

import '../../../../../view_models/attendance_view_model.dart';
import '../table/table.dart';

class WeekData extends StatelessWidget {
  const WeekData({required this.index,Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {

    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
    final weeksList = attendanceViewModel.weeksList;

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
          Text('${DateTime.parse(attendanceViewModel
              .weekAttendanceMap[weeksList[index]]![0].weekEnd).year}- ${DateTime.parse(attendanceViewModel
              .weekAttendanceMap[weeksList[index]]![0].weekEnd).month}'),
        ],),
        childrenPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          InteractiveViewer(
            child:TableData(week:attendanceViewModel
                .weekAttendanceMap[weeksList[index]],) ,
          ),
          const SizedBox(height: 20),
          Text(
              'المبلغ الكلي : ${attendanceViewModel.totalSalary(attendanceViewModel.weekAttendanceMap[weeksList[index]]!)}'),
          Text(
              'المبلغ المدفوع : ${attendanceViewModel.sumSalaryReceived(attendanceViewModel.weekAttendanceMap[weeksList[index]]!)}'),
          Text(
              "المبلغ المتبقي : ${attendanceViewModel.totalSalary(attendanceViewModel.weekAttendanceMap[weeksList[index]]!)-attendanceViewModel.sumSalaryReceived(attendanceViewModel.weekAttendanceMap[weeksList[index]]!)}"),
          const SizedBox(height: 10),
          WeekStatus(index: index, weeks: weeksList[index],)
        ],
      ),
    );
  }
}






