import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../backup/backup_view.dart';
import '../../../../components/constant.dart';

class BackupDrawer extends StatelessWidget {
  const BackupDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5),
      child: ListTile(
        onTap: () {
          push(screen: const BackupView(), context: context);
        },
        leading: const Icon(Icons.backup_rounded, size: 24, color: AppColors.accent),
        title: Text(
          'نسخ احتياطي',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
      ),
    );
  }
}
