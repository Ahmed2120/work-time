import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';
import '../../components/constant.dart';
import '../../components/functions.dart';
import '../../home/components/bottom_sheet/addingUser_bottomSheet.dart';

AppBar appBar(UserProvider userProvider, BuildContext context,User user,GlobalKey<ScaffoldState> keyScaffold){
  final List<PopupMenuItem<String>> menuItems = [
    const PopupMenuItem(
      value: 'add',
      child: Text(
        "تعديل",
        style: TextStyle(fontSize: 18),
      ),
    ),
    const PopupMenuItem(
      value: 'remove',
      child: Text(
        "حذف",
        style: TextStyle(fontSize: 18),
      ),
    ),
  ];
  return  AppBar
    (
      title: const Text('التفاصيل'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (x) {
            if(x=='remove'){
              final userModel=User(id: user.id,name: user.name, job: user.job, salary: user.salary,isDeleted: 1);
              userProvider.updateUser(userModel);
              pop(context);
              showToast(context, 'تم حذف العامل ونقله الي خارج العمل',color: const Color(0xFFE94560));
            }
            else{
              keyScaffold.currentState!.showBottomSheet((context) => ChangeNotifierProvider.value(value: user,child: AddingUserBottomSheet(user: user,)));
            }
          },
          itemBuilder: (BuildContext context) {
            return menuItems.toList();
          },
        )
      ],
    );
}