import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:work_time/provider/user_provider.dart';

import 'components/bottomSheet.dart';
import 'components/build_card.dart';
import 'components/slid_borrom_sheet.dart';
import 'components/text_row.dart';

class UserDetail extends StatelessWidget {
   UserDetail({Key? key}) : super(key: key);

   final List<PopupMenuItem<String>> menuItems = [
     const PopupMenuItem(
       value: 'add',
       child: Text("تعديل",style: TextStyle(fontSize: 18),),
     ),
     const PopupMenuItem(
       value: 'remove',
       child: Text("حذف",style: TextStyle(fontSize: 18),),
     ),
   ];
   final keyScaffold=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<UserProvider>(
        builder: (ctx,userProvider,_){
          return Scaffold(
            key: keyScaffold,
            appBar: AppBar(
              title: const Text('التفاصيل'),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (x) {},
                  itemBuilder: (BuildContext context) {
                    return menuItems.toList();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildElevatedButton(
                        label: 'حاضر',
                        color: Colors.green,
                        onPressed: () {
                         keyScaffold.currentState!.showBottomSheet((context) => RecordAttendance());
                        },
                      ),
                      const SizedBox(width: 20),
                      buildElevatedButton(
                        label: 'غائب',
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BuildCard(Column(
                    children: [
                      TextRow(title: 'الاسم', txt: userProvider.userModel.name),
                      TextRow(title: 'الوظيفة', txt: userProvider.userModel.job),
                      TextRow(title: 'الفئة', txt: userProvider.userModel.salary.toString()),
                    ],
                  )),
                  const SizedBox(height: 20),
                  const Text('التمام اليومي',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                  BuildCard(Column(
                    children: [
                      TextRow(title: 'الاسم', txt: userProvider.userModel.name),
                      TextRow(title: 'الوظيفة', txt: userProvider.userModel.job),
                      TextRow(title: 'الفئة', txt: userProvider.userModel.salary.toString()),
                    ],
                  )),
                  const SizedBox(height: 30),
                  buildElevatedButton(label: 'عرض ايام الحضور', color: const Color(
                      0xec05675e), onPressed: ()=>showSheet(context))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton buildElevatedButton(
      {required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }
}
