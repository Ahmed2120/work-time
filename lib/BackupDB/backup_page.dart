import 'package:flutter/material.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/users/components/functions.dart';

import 'backup_db_helper.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نسخ احتياطي'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF000817),
       body:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Padding(
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
                  title:  const Text('نسخ إحتياطي',style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
                )),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        width: 3,
                        color: const Color(0xFF315fbb)
                    ),
                ),
                child: ListTile(
                  trailing: const Icon(Icons.restore,size: 35,color: Colors.white,),
                  onTap:()=>BackupHelper().restoreDB(context),
                  title:  const FittedBox(child: Text('إستعادة النسخة الاحتياطية',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                )),
          ),
        ],
      ),
    );
  }

  Padding buildPadding({required Color color,required bool isBorder,required Color borderColor,required IconData icon,required String title,required Function function}) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 3,
                color: borderColor
              ),
              color: color
            ),
            child: ListTile(
              trailing: Icon(icon,size: 30,color: Colors.white,),
              onTap:()=>function(),
              title:  Text(title,style: const TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
          )),
        );
  }
}
