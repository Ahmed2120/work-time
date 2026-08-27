
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

Future<void> showFlushBar(BuildContext context, {String? customMessage}) async {
  await Flushbar(
    backgroundColor: const Color(0xFF0F172A),
    titleColor: Colors.white,
    titleSize: 16,
    messageColor: const Color(0xFF94A3B8),
    messageSize: 13,
    icon: const Icon(Icons.lock_clock_rounded, color: Color(0xFFEA580C), size: 28),
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    borderRadius: BorderRadius.circular(16),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
    mainButton: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFEA580C),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      onPressed: () {
        push(screen: const PurchaseApp(), context: context);
      },
      child: Text(
        AppConfig.isPlayStore ? 'ترقية الحساب' : 'تفعيل الترخيص',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    ),
    title: AppConfig.isPlayStore ? 'انتهت الفترة التجريبية' : 'النسخة التجريبية',
    message: customMessage ??
        (AppConfig.isPlayStore
            ? 'انتهت فترة التجربة المجانية (14 يوماً). يرجى الاشتراك لمتابعة إضافة العمال وتسجيل الحضور.'
            : 'هذه نسخة تجريبية محدودة الاستخدام. قم بتفعيل الترخيص للاستخدام الكامل.'),
    duration: const Duration(seconds: 4),
  ).show(context);
}





