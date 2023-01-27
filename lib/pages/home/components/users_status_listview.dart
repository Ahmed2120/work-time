import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/db/attendanceReposetory.dart';
import 'package:work_time/pages/EmptyScreen/epmty_screen.dart';
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
        List<User> users = userProvider.users;
        return users.isNotEmpty?ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 10),
            child: Card(
              color: const Color(0xFFF7F7F7),
              child: ListTile(
                onTap: () async {
                  pro.getWeeks(users[index].id!);
                  pro.getAttendanceUserToDay(userId: users[index].id!).then((value) {
                   if(pro.attendanceModel.isNotEmpty) pro.checkOverTime(pro.attendanceModel.last);
                  });
                  pro.getAttendanceUser(users[index].id!);
                  push(screen: UserDetail(user: users[index],),context: context);
                },
                title: Text(users[index].name,style: const TextStyle(fontSize: 16,color: Color(0xFF17263D)),),
                trailing: Consumer<AttendanceProvider>(
                  builder: (ctx, attendProvider, _) => FutureBuilder(
                      future: attendProvider.getAttendByUserAndDate(
                          userId: users[index].id!),
                      builder: (context, snapshot) {
                        final title = snapshot.data == null
                            ? 'لم يسجل'
                            : snapshot.data!.status == 1
                                ? 'حاضر'
                                : 'غائب';
                        return CustomStatusText(title);
                      }),
                ),
              ),
            ),
          ),
        ):SingleChildScrollView(child: EmptyScreen(title: 'من فضلك اضف عملاء'));
      },
    );
  }
}
