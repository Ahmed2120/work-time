
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:toast/toast.dart';

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