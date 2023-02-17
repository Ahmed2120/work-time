import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:work_time/utility/global_methods.dart';

import '../../../../model/attendance.dart';
import '../../../../provider/attendance_provider.dart';
import 'components/week_data.dart';
import 'components/week_status.dart';
import 'table/components/table_header.dart';
import 'table/components/table_rows.dart';
import 'table/table.dart';

Future showSheet(BuildContext context) => showSlidingBottomSheet(context,
    builder: (context) => const SlidingSheetDialog(
        cornerRadius: 20,
        duration: Duration(milliseconds: 200),
        avoidStatusBar: true,
        snapSpec: SnapSpec(
          snappings: [.4, .7],
        ),
        builder: buildSheet,
        headerBuilder: buildHeader));

Widget buildHeader(context, state) => Material(
      child: SizedBox(
        height: 10,
        child: Container(
          width: 60,
          decoration: BoxDecoration(
              color: const Color(0xFF533483),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );

Widget buildSheet(context, state) {
  return Material(
    child: ListView.builder(
        itemCount:  Provider.of<AttendanceProvider>(context).weeksList.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) => WeekData(index: index,)),
  );
}

