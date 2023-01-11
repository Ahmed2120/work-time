import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/user_provider.dart';
import '../../utility/global_methods.dart';
import 'components/custon_add_button.dart';
import 'components/dropDownMenuRow.dart';
import 'components/users_status_listview.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final keyScaffold=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        title: Text('${GlobalMethods.getDayName(DateTime.now())} ${GlobalMethods.getDateFormat(DateTime.now())}'),
      centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropDownMenuRow(
            values: const [
                    'الكل',
                    '100',
                    '200',
                    '300',
            ],
            onChange: () {},
          ),
                     CustomAddButton(keyScaffold),
                  ],
                ),
              )),
          const Expanded(
            flex: 7,
            child: UsersStatusListview(),
          ),
        ],
      ),
    );
  }
}