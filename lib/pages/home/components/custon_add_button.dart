

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import 'addingUser_bottomSheet.dart';
import 'package:path/path.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(this.keyScaffold,{Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> keyScaffold;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async{
        keyScaffold.currentState!.showBottomSheet((context) => AddingUserBottomSheet('add'));
      },
      child: Row(
        children: const [
          Text('اضافة'),
          Icon(Icons.add)
        ],
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async{
if(await permission.isGranted){
  return true;
}else{
  var result = await permission.request();
  if( result == PermissionStatus.granted){
    return true;
  }else{
    return false;
  }
}
  }

}
