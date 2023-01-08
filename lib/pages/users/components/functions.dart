
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
          color: Colors.yellow,
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

showToast(BuildContext context) {
  final toast = ToastContext();
  toast.init(context);
  Toast.show('تم تسجيل التمام مسبقاً',
      duration: Toast.lengthLong,
      backgroundColor: const Color(0xFFBB4724),
      textStyle: const TextStyle(color: Color(0xFFFFFFFF)));
}