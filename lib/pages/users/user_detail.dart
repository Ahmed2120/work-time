import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/custom_textField.dart';
import 'package:work_time/provider/attendance_provider.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../model/user.dart';
import 'components/appbar.dart';
import 'components/attendance.dart';
import 'components/attendance_detail.dart';
import 'components/button_attendance.dart';
import 'components/draw_money.dart';
import 'components/build_card.dart';
import 'components/over_time.dart';
import 'components/slid_bottom_sheet/slid_bottom_sheet.dart';
import 'components/text_row.dart';
import 'components/user_data.dart';

class UserDetail extends StatelessWidget {
  UserDetail({Key? key, required this.user}) : super(key: key);
  final User user;

  final _keyScaffold = GlobalKey<ScaffoldState>();
  final _formKey=GlobalKey<FormState>();
  final _workPlaceController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: true);
    final model=attendanceProvider.attendanceModel;

    return Consumer<UserProvider>(
      builder: (ctx, userProvider, _) {
        return Scaffold(
          key: _keyScaffold,
          appBar: appBar(userProvider, context,user,_keyScaffold),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListView(
          physics: BouncingScrollPhysics(),
              children: [
                AttendanceWidget(_formKey, user: user, workPlace: _workPlaceController.text,),
                const SizedBox(height: 10),
                Form(key: _formKey,
                    child: CustomTextField(
                  controller: _workPlaceController, label: 'مكان العمل',
                )),
                const SizedBox(height: 15),
               UserData(user: user),
                const SizedBox(height: 10),
                 Text(
                  'التمام اليومي',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
                ),
                BuildCard(
                    Column(
                  children: [
                    TextRow(
                        title: 'التمام',
                        txt: model.isEmpty
                            ? 'لم يتم تسجيل التمام'
                            : attendanceProvider.attendanceText),
                    if (model.isNotEmpty && model.last.status==1)
                      AttendanceDetail()
                  ],
                )),
                const SizedBox(height: 15),
                if (model.isNotEmpty && model.last.status==1)
                  ButtonAttendance(
                      label: 'سحب مبلغ',
                      color: const Color(0xffE94560),
                      onPressed: () {
                        _keyScaffold.currentState!
                            .showBottomSheet((context) => ChangeNotifierProvider.value(
                            value: user,
                            child: DrawFinance()));
                      }),
                const SizedBox(height: 10),
                ButtonAttendance(
                    label: 'عرض ايام الحضور',
                    color: const Color(0xFF533483),
                    onPressed: () {
                      attendanceProvider.getWeeklyAttendance(user.id!).then((value) {
                        attendanceProvider
                            .getAttendanceUser(user.id!);
                        showSheet(context);
                      });
                    }),
                if (model.isNotEmpty && model.last.status==1)
                 const OverTime()
              ],
            ),
          ),
        );
      },
    );
  }

}