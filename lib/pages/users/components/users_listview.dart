import 'package:flutter/material.dart';

import '../../../model/user.dart';

class UsersListview extends StatelessWidget {
  const UsersListview(this.users, {Key? key}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(users[index].name),
              subtitle: Text(getHour()),
              // trailing: CustomStatusText(users[index].status),
            ),
          ),
        );
  }

  String getHour(){
    final date = DateTime.now();
    return date.hour > 12 ? '${date.hour - 12}:${date.minute}  م' : '${date.hour}:${date.minute}  ص';
  }
}