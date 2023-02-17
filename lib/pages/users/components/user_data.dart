import 'package:flutter/material.dart';

import 'build_card.dart';
import 'text_row.dart';

class UserData extends StatelessWidget {
  const UserData({required this.user,Key? key}) : super(key: key);
  final user;

  @override
  Widget build(BuildContext context) {
    return  BuildCard(Column(
      children: [
        TextRow(title: 'الاسم', txt: user.name),
        TextRow(
            title: 'الوظيفة', txt: user.job),
        TextRow(
            title: 'الفئة',
            txt: user.salary.toString()),
      ],
    ));
  }
}
