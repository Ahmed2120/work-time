
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/components/functions.dart';
import 'package:work_time/view_models/note_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';

class BackupHelper{

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
      File ourDbFile=File('/data/data/com.ashraf.workTime/databases/dgi.db');
      Directory? folderPathForDBFile=Directory('/storage/emulated/0/Download/WorkTime');
      await folderPathForDBFile.create();
      await ourDbFile.copy('/storage/emulated/0/Download/WorkTime/dgi.db');
      showToast(context, 'storage/emulated/0/WorkTime/dgi.db تمت عملية النسخ الاحتساطي بنجاح في المسار المحدد \n ');
    pop(context);
    }
    catch(e){
      showToast(context, 'حدث خطأ اعد فتح التطبيق وحاول مرة اخري',color: Colors.red);
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
          await saveBDFile.copy('/data/data/com.ashraf.workTime/databases/dgi.db');
          Provider.of<UserViewModel>(context,listen: false).getUsers();
         Provider.of<NoteViewModel>(context,listen: false).getNotes();
         Provider.of<UserViewModel>(context,listen: false).getTrash();
          showToast(context, 'تم استرجاع النسخة الاحتياطية');
          pop(context);
        }
      }
    catch(e){
      showToast(context, 'storage/emulated/0/Download/WorkTime/dgi.db خطأ تأكد من وجود ملف البيانات في المسار المحدد \n ',color: Colors.red);
    }
  }
}





