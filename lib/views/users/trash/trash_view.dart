import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/users/trash/components/card_trash.dart';

import '../../../data/models/user.dart';
import '../../../view_models/user_view_model.dart';
import '../../EmptyScreen/empty_screen.dart';

class TrashView extends StatelessWidget {
  const TrashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('خارج العمل'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      body: Consumer<UserViewModel>(
        builder: (ctx, userViewModel, _) {
          List<User> userTrash = userViewModel.usersTrash;
          return userTrash.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: userTrash.length,
                  itemBuilder: (ctx, index) => CustomCardTrash(userTrash[index]),
                )
              : const EmptyScreen(title: 'لا يوجد عمال خارج العمل حالياً');
        },
      ),
    );
  }
}
