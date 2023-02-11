

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_time/cash_helper.dart';
import 'package:work_time/pages/home/purchase_app.dart';
import 'package:work_time/pages/users/components/functions.dart';

import '../../../BackupDB/backup_page.dart';
import '../../components/constant.dart';
import '../../start_page.dart';

class MainDrawer extends StatelessWidget {
  Widget buildDrawer(String text, IconData icon, VoidCallback HandDrawer,BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).buttonColor,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1?.color,
            fontSize: 24,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold),
      ),
      onTap: HandDrawer,
    );
  }

  @override
  Widget build(BuildContext context){
    //var lan=Provider.of<LanguageProvider>(context,listen: true);
    return Drawer(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                'WorkTime',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
            color: const Color(0xFF16213E)
          ),
          SizedBox(
            height: 20,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
          child: ListTile(
            onTap: () {
              push(screen: const BackupPage(), context: context);
            },
            leading:const Icon(Icons.backup,size: 25,color:Color(0xFFE94560)) ,
            title:Text('نسخ احتياطي',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, ),) ,
            trailing: Icon(FontAwesomeIcons.chevronRight),
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(height: 10,color: Colors.black38,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.cartShopping,size: 25,color:Color(0xFFE94560)),
              trailing: Icon(FontAwesomeIcons.chevronRight),
              title:Text('شراء التطبيق',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, )), 
              onTap: (){if(!trial) {
            showToast(context, 'لقد قمت بشراء التطبيق');
            return;
            }
            push(screen: PurchaseApp(), context: context);},
            ),
          ),
        ],
      ),
    );
  }
}
