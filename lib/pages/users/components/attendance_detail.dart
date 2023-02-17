import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/attendance_provider.dart';
import 'text_row.dart';

class AttendanceDetail extends StatelessWidget {
  const AttendanceDetail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: true);
    final model=attendanceProvider.attendanceModel.last;
    return Column(
      children: [
        TextRow(title: 'اليوم', txt: attendanceProvider.date),
        TextRow(title: 'الساعه', txt: attendanceProvider.time),
        TextRow(title: 'مكان العمل ', txt: model.workPlace),
        TextRow(
            title: 'المبلغ المسحوب',
            txt: model.salaryReceived),
        TextRow(
            title: 'الوقت الإضافي',
            txt: model.overTimeStatus==1?'تم إضافة سهرة':'لا يوجد'),
      ],
    );
  }
}
