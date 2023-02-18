import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/user.dart';

import '../../../../provider/user_provider.dart';
import 'components/form_sheet.dart';
import 'components/header_sheet.dart';

// ignore: must_be_immutable
class AddingUserBottomSheet extends StatelessWidget {
  AddingUserBottomSheet({this.user,Key? key}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
           HeaderSheet(title:user != null?'تعديل':'اضافة عامل',),
          const SizedBox(height: 40),
        FormSheet(user:user),
        ],
      ),
    );
  }

}
