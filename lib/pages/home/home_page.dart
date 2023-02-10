import 'package:flutter/material.dart';

import '../../utility/global_methods.dart';
import '../users/components/main_drawer.dart';
import 'components/custom_appbar.dart';
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
      appBar: customAppBar(context),
      body: Column(
        children: [
          Expanded(
            flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropDownMenuRow(),
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
      drawer: MainDrawer(),
    );
  }
}