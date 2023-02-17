import 'package:flutter/material.dart';

import 'components/drawer/main_drawer.dart';
import 'components/custom_appbar.dart';
import 'components/custom_add_button.dart';
import 'components/dropDownMenuRow.dart';
import 'components/users_status_listview.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final keyScaffold=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final landScape=MediaQuery.of(context).orientation==Orientation.landscape;
    return Scaffold(
      key: keyScaffold,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Expanded(
            flex: landScape?2:1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    DropDownMenuRow(),
                     Spacer(),
                     CustomAddButton(keyScaffold),
                  ],
                ),
              )),
          const Expanded(
            flex: 9,
            child: UsersStatusListview(),
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}