import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/users/trash/components/card_trash.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';
import '../../EmptyScreen/empty_screen.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خارج العمل'),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder:(ctx, userProvider, _){
      List<User> userTrash = userProvider.usersTrash;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
        child: userTrash.isNotEmpty?ListView.builder(
            physics: BouncingScrollPhysics(),
          itemCount: userTrash.length
        ,itemBuilder: (ctx,index)=>CustomCardTrash(userTrash[index])):EmptyScreen(title: 'لا يوجد عملاء خارج العمل',),
      );}),
    );
  }
}
