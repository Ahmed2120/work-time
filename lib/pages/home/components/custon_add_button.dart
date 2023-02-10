

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_time/cash_helper.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../users/components/functions.dart';
import 'addingUser_bottomSheet.dart';
import 'package:path/path.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(this.keyScaffold,{Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> keyScaffold;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50,
            maxWidth: 100
        ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 29, 53, 87)
        ),
        onPressed: () async{
          final provider=Provider.of<UserProvider>(context,listen: false);
          if((provider.users.length+provider.usersTrash.length)>=5&&trial) {
            showFlushBar(context);
          }
          else{
            keyScaffold.currentState!
              .showBottomSheet((context) => AddingUserBottomSheet('add'));

          }
        },
        icon: const Text('اضافة',),
        label: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

}
