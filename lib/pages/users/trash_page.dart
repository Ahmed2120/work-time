import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/user_provider.dart';
import 'components/users_listview.dart';
import 'ff.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<UserProvider>(
        builder:(ctx, userProvider, _){
      List<User> users = userProvider.usersTrash;
      return ScrollingText(
        text: "Osama Ibrahim Sadek",
        textStyle: TextStyle(fontSize: 18),
      );}),
    );
  }
}
