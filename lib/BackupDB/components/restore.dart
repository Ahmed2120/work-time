import 'package:flutter/material.dart';

import '../backup_db_helper.dart';

class Restore extends StatelessWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          title: FittedBox(child: Text('إستعادة النسخة الاحتياطية',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color(0xFF315fbb)),)),
        ),
      ),
    );
  }
}
