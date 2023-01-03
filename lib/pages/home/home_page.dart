import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import 'components/dropDownMenuRow.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              flex: 1,
                child: DropDownMenuRow(
              values: [
                'الكل',
                '100',
                '200',
                '300',
              ],
              onChange: () {},
            )),
            Expanded(
              flex: 7,
              child: Consumer<UserProvider>(
                builder:(ctx, userProvider, _)=> ListView.builder(
                  itemCount: userProvider.filteredUsers.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text('${userProvider.filteredUsers[index].name}'),
                      subtitle: Container(
                        width: 1,
                        height: 10,
                        color: userProvider.filteredUsers[index].status == 'حاضر'
                            ? Colors.green
                            : Colors.red,
                      ),
                      trailing: Text('${userProvider.filteredUsers[index].status}'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
