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
        text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more ",
        textStyle: TextStyle(fontSize: 12),
      );}),
    );
  }
}
