import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/cash_helper.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../../Theme/theme.dart';
import '../../components/functions.dart';
import 'bottom_sheet/addingUser_bottomSheet.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(this.keyScaffold,{Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> keyScaffold;

  @override
  Widget build(BuildContext context) {
    final landScape=MediaQuery.of(context).orientation==Orientation.landscape;
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Container(
        constraints: BoxConstraints(
            maxHeight: landScape?height*.11:height*.06,
            maxWidth:  landScape?width*.12:width*.24
        ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultColor
        ),
        onPressed: () async{
          final provider=Provider.of<UserProvider>(context,listen: false);
          if((provider.users.length+provider.usersTrash.length)>=5&&trial) {
            showFlushBar(context);
            return;
          }
            keyScaffold.currentState!
              .showBottomSheet((context) => AddingUserBottomSheet());
        },
        icon: FittedBox(child: const Text('اضافة',)),
        label: FittedBox(child: const Icon(Icons.add)),
      ),
    );
  }

}
