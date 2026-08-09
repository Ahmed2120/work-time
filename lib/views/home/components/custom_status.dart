import 'package:flutter/material.dart';
import 'package:work_time/views/components/status_chip.dart';

class CustomStatusText extends StatelessWidget {
  const CustomStatusText(
    this.title, {
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return StatusChip(title: title);
  }
}
