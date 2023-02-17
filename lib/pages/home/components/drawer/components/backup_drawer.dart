import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../BackupDB/backup_page.dart';
import '../../../../components/constant.dart';

class BackupDrawer extends StatelessWidget {
  const BackupDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
      child: ListTile(
        onTap: () {
          push(screen: const BackupPage(), context: context);
        },
        leading:const Icon(Icons.backup,size: 25,color:Color(0xFFE94560)) ,
        title:Text('نسخ احتياطي',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)) ,
        trailing: Icon(FontAwesomeIcons.chevronRight),
      ),
    );
  }
}
