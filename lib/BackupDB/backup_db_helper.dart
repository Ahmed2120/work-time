
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/users/components/functions.dart';
import 'package:work_time/provider/note_provider.dart';
import 'package:work_time/provider/user_provider.dart';

class BackupHelper{
  getDbPath()async{
    String databasePath=await getDatabasesPath();
    print('===============databasePath= $databasePath');
    Directory? externalStoragePath=await getExternalStorageDirectory();
    print('===============externalStoragePath= $externalStoragePath');
  }
  backupDB(BuildContext context)async{
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
      Directory? folderPathForDBFile=Directory('/storage/emulated/0/Download/WorkTime');
      await folderPathForDBFile.create();
      await ourDbFile.copy('/storage/emulated/0/Download/WorkTime/dgi.db');
      showToast(context, 'storage/emulated/0/WorkTime/dgi.db تمت عملية النسخ الاحتساطي بنجاح في المسار المحدد \n ');
    pop(context);
    }
    catch(e){
      showToast(context, 'حدث خطأ اعد فتح التطبيق وحاول مرة اخري',color: Colors.red);
      print('======================================error ${e.toString()}');
    }
  }

  restoreDB(BuildContext context)async{
    var status=await Permission.manageExternalStorage.status;
    if(!status.isGranted){
      await Permission.manageExternalStorage.request();
    }
    var status1=await Permission.storage.status;
    if(!status1.isGranted){
      await Permission.storage.request();
    }

    try{
    String path='/storage/emulated/0/Download/WorkTime/dgi.db';
        List<String> listPath=path.split('/');
        if(listPath.last=='dgi.db'){
         File saveBDFile=File(path);
          await saveBDFile.copy('/data/data/com.ahmad.work_time/databases/dgi.db');
          Provider.of<UserProvider>(context,listen: false).getUsers();
         Provider.of<NoteProvider>(context,listen: false).getNotes();
          showToast(context, 'تم استرجاع النسخة الاحتياطية');
          pop(context);
        }
      }
    catch(e){
      showToast(context, 'storage/emulated/0/Download/WorkTime/dgi.db خطأ تأكد من وجود ملف البيانات في المسار المحدد \n ',color: Colors.red);
      print('======================================error ${e.toString()}');
    }
  }

  deleteDB()async{
    try{
      deleteDatabase('/data/data/com.ahmad.work_time/databases/dgi.db');
    }catch(e){
      print('======================================error ${e.toString()}');
    }
  }
}