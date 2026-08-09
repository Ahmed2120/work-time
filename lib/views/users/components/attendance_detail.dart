import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/attendance_view_model.dart';
import 'text_row.dart';

class AttendanceDetail extends StatelessWidget {
  const AttendanceDetail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: true);
    final model=attendanceViewModel.attendanceModel.last;
    return Column(
      children: [
        TextRow(title: 'اليوم', txt: attendanceViewModel.date),
        TextRow(title: 'الساعه', txt: attendanceViewModel.time),
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






