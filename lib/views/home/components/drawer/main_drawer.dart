import 'package:flutter/material.dart';
import 'package:work_time/core/utils/cache_helper.dart';

import 'components/backup_drawer.dart';
import 'components/purchase_drawer.dart';
import 'components/theme_drawer.dart';
import 'components/title_drawer.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleDrawer(),
          const SizedBox(height: 10),
          const BackupDrawer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(height: 10, color: Colors.black26),
          ),
          const ThemeDrawer(),
          if (trial)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(height: 10, color: Colors.black26),
            ),
          if (trial) const PurchaseDrawer(),
        ],
      ),
    );
  }
}
