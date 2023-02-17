import 'package:flutter/material.dart';
import 'package:work_time/cash_helper.dart';

import 'components/backup_drawer.dart';
import 'components/purchase_drawer.dart';
import 'components/title_drawer.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Drawer(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         TitleDrawer(),
          SizedBox(height: 10),
        BackupDrawer(),
          if(trial) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(height: 10,color: Colors.black38,),
          ),
          if(trial) PurchaseDrawer(),
        ],
      ),
    );
  }
}
