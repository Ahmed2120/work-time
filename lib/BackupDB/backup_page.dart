import 'package:flutter/material.dart';
import 'package:work_time/pages/components/constant.dart';

import '../Theme/theme.dart';
import 'components/backup.dart';
import 'components/restore.dart';
import 'components/steps.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color(0xFF000817),
        leading: IconButton(onPressed: () {
          pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white),),
      ),
      backgroundColor: const Color(0xFF000817),
       body:Center(
         child: SingleChildScrollView(
           child: Column(
            children: [
              const Steps(),
              const SizedBox(height: 30),
              const Backup(),
              const SizedBox(height: 20),
             const Restore() ,
            ],
      ),
         ),
       ),
    );
  }
  }
