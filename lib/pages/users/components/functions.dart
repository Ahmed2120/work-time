
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:toast/toast.dart';
import 'package:work_time/pages/components/constant.dart';

import '../../home/purchase_app.dart';

AlertDialog alert(
    {required BuildContext context,required String txt,required Color color,required VoidCallback onPressed}) {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(
            IconlyBold.danger,
          color: Colors.amber,
          size: 40,
        ),
        Text(
          'تعديل تمام',
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
        ),
      ],
    ),
    content:
    Text.rich(TextSpan(text: 'سوف تقوم بتعديل التمام وجعله ', children: <InlineSpan>[
      TextSpan(
        text: txt,
        style: TextStyle(fontWeight: FontWeight.bold,color: color),
      )
    ])),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel')),
      TextButton(onPressed: onPressed, child: Text('Ok',style: TextStyle(color: Color(0xFFE94560)),)),
    ],
  );
}

Widget buildToast(){
  return Builder(builder: (context)=>showToast(context, ''));
}

showToast(BuildContext context,String txt, {Color color = Colors.green}) {
  final toast = ToastContext();
  toast.init(context);
  Toast.show(txt,
      duration: Toast.lengthLong,
      backgroundColor: color,
      textStyle: const TextStyle(color: Color(0xFFFFFFFF)));
}

Future<void> showFlushBar(BuildContext context)async {
  await Flushbar(
    backgroundColor: Color(0xF9D5CFCF).withOpacity(.2),
    titleColor:Color.fromARGB(255, 29, 53, 87),
    titleSize: 20,
    messageColor: Color(0xFF533483),
    icon: Icon(Icons.info),
    forwardAnimationCurve: Curves.linearToEaseOut,
    reverseAnimationCurve: Curves.linearToEaseOut,
    mainButton: TextButton(onPressed: (){
      push(screen: PurchaseApp(), context: context);
    },child:Text('شراء التطبيق',style: TextStyle(fontSize: 17,color: Colors.blue),) ,),
      title: 'النسخة التجريبية',
      message:
      'هذه نسخه تجريبية محدودة الاستخدام قم بشراء التطبيق للاستخدام الكامل',
   //   margin: EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20)
      ),
      duration: Duration(seconds: 7),
  ).show(context);
}