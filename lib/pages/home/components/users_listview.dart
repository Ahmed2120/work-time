import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';

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
              title: Text('${users[index].name}'),
              subtitle: Container(
                width: 1,
                height: 10,
                color: users[index].status == 'حاضر'
                    ? Colors.green
                    : Colors.red,
              ),
              trailing: Text('${users[index].status}'),
            ),
          ),
        );},
    );
  }
}
