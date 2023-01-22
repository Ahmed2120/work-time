import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/provider/user_provider.dart';

import '../provider/note_provider.dart';
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 3,
                color: const Color(0xFF315fbb)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('خطوات استرجاع النسخة الاحتياطية',style: TextStyle(color: const Color(0xFF315fbb),fontWeight: FontWeight.w700,fontSize: 20),textAlign: TextAlign.center),
                SizedBox(height: 10),
                Text('1 تحميل الملف من جوجل دريف '),
                Text('2 نسخ الملف في المسار المحدد '),
                Text('3 المسار \n storage/emulated/0/WorkTime/dgi.db '),
                Text('4 الضغط علي استرجاع النسخة الاحتياطية '),
              ],
            ),
          ),
          SizedBox(height: 30),
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
                  color: const Color(0xfffaf9f9),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        width: 3,
                        color: const Color(0xFF315fbb)
                    ),
                ),
                child: ListTile(
                  trailing: const Icon(Icons.cloud_download_rounded,size: 35,color: Color(0xFF315fbb),),
                  onTap:(){
                    BackupHelper().restoreDB(context);
                  },
                  title:  const FittedBox(child: Text('إستعادة النسخة الاحتياطية',style: TextStyle(color: Color(0xFF315fbb),fontWeight: FontWeight.bold),)),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPadding({required Color color,required Color borderColor,required IconData icon,required String title,required Function function}) {
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
              onTap:()=>function,
              title:  Text(title,style: const TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
          )),
        );
  }
}
