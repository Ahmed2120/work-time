import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/BackupDB/backup_page.dart';
import 'package:work_time/pages/components/constant.dart';

import '../../../provider/attendance_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utility/global_methods.dart';

AppBar customAppBar(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);
  final attendanceProvider = Provider.of<AttendanceProvider>(context);
  return !userProvider.clickSearch
        ? AppBar(
    leading: IconButton(
      onPressed: () => userProvider.changeClickSearch(),
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
    ),
          actions: [IconButton(onPressed: () async{
            attendanceProvider.changeDate(await showDatePicker(context: context, initialDate: attendanceProvider.dateTimeAttendance, firstDate: DateTime.parse('1900-01-01'), lastDate: DateTime.now(),));
          }, icon: const Icon(Icons.date_range_outlined)),
            IconButton(onPressed: () {
            push(screen: const BackupPage(), context: context);
          }, icon: const Icon(Icons.settings)),

          ],
          title: Text(
            '${GlobalMethods.getDayName(attendanceProvider.dateTimeAttendance)} ${GlobalMethods.getDateFormat(attendanceProvider.dateTimeAttendance)}',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
    centerTitle: true,
        )
        : AppBar(
          title: TextField(
              onChanged: (txt) {
                if(txt.isEmpty){
                  userProvider.getUsers();
                  return;
                }
                userProvider.searchUsers(txt);
              },
              decoration: InputDecoration(
                  focusColor: Colors.red,
                  hintText: "بحث",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      userProvider.changeClickSearch();
                      userProvider.getUsers();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xFFE94560),
                    ),
                  )),
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              cursorColor: const Color(0xFF533483),
            ),
    centerTitle: true,
        );
}
