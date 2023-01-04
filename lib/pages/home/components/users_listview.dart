import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';
import 'custom_status.dart';

class UsersListview extends StatelessWidget {
  const UsersListview({Key? key}) : super(key: key);

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
              title: Text(users[index].name),
              subtitle: Text(getHour()),
              trailing: CustomStatusText(users[index].status),
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