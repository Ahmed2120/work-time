import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

class TitleDrawer extends StatelessWidget {
  const TitleDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: const Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Text(
          'WorkTime',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
