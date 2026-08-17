
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:toast/toast.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/views/components/constant.dart';

import '../purchase/purchase_app.dart';

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
    backgroundColor: Color(0xFFF9BBB0),
    titleColor:Color.fromARGB(255, 29, 53, 87),
    titleSize: 20,
    messageColor: Color(0xFF533483),
    icon: Icon(Icons.info,color: Colors.black,),
    forwardAnimationCurve: Curves.linearToEaseOut,
    reverseAnimationCurve: Curves.linearToEaseOut,
    mainButton: TextButton(
      onPressed: () {
        push(screen: const PurchaseApp(), context: context);
      },
      child: Text(
        AppConfig.isPlayStore ? 'شراء التطبيق' : 'تفعيل الترخيص',
        style: const TextStyle(fontSize: 15, color: Colors.blue, fontFamily: 'Cairo'),
      ),
    ),
      title: 'النسخة التجريبية',
      message:
      'هذه نسخه تجريبية محدودة الاستخدام قم بشراء التطبيق للاستخدام الكامل',
   //   margin: EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20)
      ),
      duration: Duration(seconds: 2),
  ).show(context);
}





