
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

AlertDialog alert(
    {required BuildContext context,required String txt,required Color color,required VoidCallback onPressed}) {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(
          Icons.warning_amber,
          color: Color(0xFF2C0202),
        ),
        Text(
          'تعديل تمام',
          style: TextStyle(fontSize: 14),
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
      TextButton(onPressed: onPressed, child: Text('Ok')),
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