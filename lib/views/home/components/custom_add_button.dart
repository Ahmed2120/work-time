import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/view_models/user_view_model.dart';

import '../../components/functions.dart';
import 'bottom_sheet/addingUser_bottomSheet.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(this.keyScaffold, {super.key});
  final GlobalKey<ScaffoldState> keyScaffold;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final provider = Provider.of<UserViewModel>(context, listen: false);
            if ((provider.users.length + provider.usersTrash.length) >= AppConfig.maxTrialWorkers && trial) {
              showFlushBar(context);
              return;
            }
            keyScaffold.currentState!
                .showBottomSheet((context) => AddingUserBottomSheet());
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_add_alt_1_rounded, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'إضافة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
