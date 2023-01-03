import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/user_provider.dart';
import 'components/dropDownMenuRow.dart';
import 'components/users_listview.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              flex: 1,
                child: DropDownMenuRow(
              values: const [
                'الكل',
                '100',
                '200',
                '300',
              ],
              onChange: () {},
            )),
            const Expanded(
              flex: 7,
              child: UsersListview(),
            ),
          ],
        ),
      ),
    );
  }
}
