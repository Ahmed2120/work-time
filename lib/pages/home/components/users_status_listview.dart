import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/db/attendanceReposetory.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/provider/attendance_provider.dart';
import 'package:work_time/utility/global_methods.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';
import '../../users/user_detail.dart';
import 'custom_status.dart';

class UsersStatusListview extends StatelessWidget {
  const UsersStatusListview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<AttendanceProvider>(context, listen: false);
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, _) {
        List<User> users = userProvider.filteredUsers.isEmpty
            ? userProvider.users
            : userProvider.filteredUsers;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: () async {
                pro.getWeeks(users[index].id!);
                pro.setSalary(double.parse(users[index].salary));
                pro.getAttendanceUserToDay(userId: users[index].id!);
                pro.getAttendanceUser(users[index].id!);

                push(
                    screen: UserDetail(user: users[index],),
                    context: context);
              },
              title: Text(users[index].name),
              trailing: Consumer<AttendanceProvider>(
                builder: (ctx, attendProvider, _) => FutureBuilder(
                    future: attendProvider.getAttendByUserAndDate(
                        userId: users[index].id!),
                    builder: (context, snapshot) {
                      final title = snapshot.data == null
                          ? 'لم يحدد بعد'
                          : snapshot.data!.status == 1
                              ? 'حاضر'
                              : 'غائب';
                      return CustomStatusText(title
                      );
                    }),
              ),
            ),
          ),
        );
      },
    );
  }
}
