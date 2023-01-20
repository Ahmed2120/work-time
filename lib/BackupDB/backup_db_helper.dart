
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/provider/user_provider.dart';

import '../pages/users/components/functions.dart';

class BackupHelper{
  getDbPath()async{
    String databasePath=await getDatabasesPath();
    print('===============databasePath= $databasePath');
    Directory? externalStoragePath=await getExternalStorageDirectory();
    print('===============externalStoragePath= $externalStoragePath');
  }
  void backupDB(BuildContext context)async{
    var status=await Permission.manageExternalStorage.status;
    if(!status.isGranted){
      await Permission.manageExternalStorage.request();
    }
    var status1=await Permission.storage.status;
    if(!status1.isGranted){
      await Permission.storage.request();
    }

    try{
      File ourDbFile=File('/data/data/com.ahmad.work_time/databases/dgi.db');
      Directory? folderPathForDBFile=Directory('/storage/emulated/0/Download/BackUp');
      await folderPathForDBFile.create();
      await ourDbFile.copy('/storage/emulated/0/Download/BackUp/dgi.db').then((value) {
        showToast(context, '   تم عمل نسخ إحتياطي في المسار المحدد\n ${'/storage/emulated/0/Download/BackUp'}');
        pop(context);
      });
    }
    catch(e){
      showToast(context, 'خطأ',color: Colors.red);
    }
  }


  Future restoreDB(BuildContext context)async{
    var status=await Permission.manageExternalStorage.status;
    if(!status.isGranted){
      await Permission.manageExternalStorage.request();
    }
    var status1=await Permission.storage.status;
    if(!status1.isGranted){
      await Permission.storage.request();
    }

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if(result !=null){
        PlatformFile file = result.files.first;
        File fileDBPath=File(file.path!);
        List<String> listString=fileDBPath.path.toString().split('/');
        if(listString.last=='dgi.db'){
          await fileDBPath.copy('/data/data/com.ahmad.work_time/databases/dgi.db').then((value) {
            showToast(context,'تم استعادة النسخة الاحتياطية',);
            Provider.of<UserProvider>(context).getUsers();
            pop(context);

          });
        }
        else{
          showToast(context, 'هذا ليس ملف الداتا',color: Colors.red);
        }

      }

    }
    catch(e){}
  }

}