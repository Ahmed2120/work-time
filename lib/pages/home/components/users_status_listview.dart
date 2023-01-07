import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/constant.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';
import '../../users/user_detail.dart';
import 'custom_status.dart';

class UsersStatusListview extends StatelessWidget {
  const UsersStatusListview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:(ctx, userProvider, _){
        List<User> users = userProvider.filteredUsers.isEmpty ? userProvider.users :
        userProvider.filteredUsers;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: (){
                userProvider.getUser(users[index].id!);
                push(screen:  UserDetail(), context: context);
              },
              title: Text(users[index].name),
              subtitle: Text(getHour()),
              // trailing: CustomStatusText(users[index].status),
            ),
          ),
        );},
    );
  }

  String getHour(){
    final date = DateTime.now();
    return date.hour > 12 ? '${date.hour - 12}:${date.minute}  م' : '${date.hour}:${date.minute}  ص';
  }
}