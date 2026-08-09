import 'package:flutter/material.dart';
import 'package:work_time/views/components/app_card.dart';

class BuildCard extends StatelessWidget {
  const BuildCard(this.widget, {super.key});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12.0),
      child: widget,
    );
  }
}
