import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';

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
        TextRow(title: context.l10n.dayCol, txt: attendanceViewModel.date),
        TextRow(title: context.l10n.timeCol, txt: attendanceViewModel.time),
        TextRow(title: context.l10n.workplace, txt: model.workPlace),
        TextRow(
            title: context.l10n.drawnCol,
            txt: model.salaryReceived),
        TextRow(
            title: context.l10n.overtime,
            txt: model.overTimeStatus==1 ? context.l10n.overtimeAdded : context.l10n.none),
      ],
    );
  }
}






