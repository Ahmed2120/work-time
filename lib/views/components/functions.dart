
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:toast/toast.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/views/components/constant.dart';

import '../purchase/purchase_app.dart';

AlertDialog alert(
    {required BuildContext context,required String txt,required Color color,required VoidCallback onPressed}) {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          IconlyBold.danger,
          color: Colors.amber,
          size: 40,
        ),
        Text(
          context.l10n.changeAttendanceConfirm,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
        ),
      ],
    ),
    content:
    Text.rich(TextSpan(text: context.l10n.changeAttendanceMsg, children: <InlineSpan>[
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
          child: Text(context.l10n.cancel)),
      TextButton(
        onPressed: onPressed,
        child: Text(
          context.l10n.ok,
          style: const TextStyle(color: Color(0xFFE94560)),
        ),
      ),
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
  final bool wasSubscribed = await SecureStorageHelper.wasSubscribedBefore();

  final String title = customMessage != null
      ? (AppConfig.isPlayStore ? context.l10n.dialogAlert : context.l10n.trialVersion)
      : (AppConfig.isPlayStore
          ? (wasSubscribed ? context.l10n.subscriptionExpired : context.l10n.trialExpired)
          : context.l10n.trialVersion);

  final String message = customMessage ??
      (AppConfig.isPlayStore
          ? (wasSubscribed
              ? context.l10n.flushbarSubExpiredMsg
              : context.l10n.flushbarTrialExpiredMsg)
          : context.l10n.flushbarLimitedTrialMsg);

  final String buttonText = AppConfig.isPlayStore
      ? (wasSubscribed ? context.l10n.renewSubscription : context.l10n.upgradeAccount)
      : context.l10n.activateLicense;

  if (!context.mounted) return;

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
        buttonText,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    ),
    title: title,
    message: message,
    duration: const Duration(seconds: 4),
  ).show(context);
}





