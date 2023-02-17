import 'package:flutter/material.dart';

import '../backup_db_helper.dart';

class Backup extends StatelessWidget {
  const Backup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color(0xFF315fbb)
          ),
          child: ListTile(
            trailing: const Icon(Icons.backup,size: 30,color: Colors.white,),
            onTap:()=>BackupHelper().backupDB(context),
            title: Text('نسخ إحتياطي',style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
          )),
    );
  }
}
