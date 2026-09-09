import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import '../../core/constants/app_constants.dart';


class UpgraderWidget extends StatelessWidget {
  const UpgraderWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: AppConstants.upgrader,
      showIgnore: false,
      dialogStyle: UpgradeDialogStyle.cupertino,
      child: child,
    );
  }
}
