import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../data/models/user.dart';
import '../../../view_models/user_view_model.dart';
import '../../components/functions.dart';
import '../../home/components/bottom_sheet/addingUser_bottomSheet.dart';

AppBar appBar(UserViewModel userViewModel, BuildContext context, User user, GlobalKey<ScaffoldState> keyScaffold) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final List<PopupMenuItem<String>> menuItems = [
    const PopupMenuItem(
      value: 'add',
      child: Row(
        children: [
          Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryPurple),
          SizedBox(width: 8),
          Text("تعديل البيانات", style: TextStyle(fontSize: 14, fontFamily: 'Cairo')),
        ],
      ),
    ),
    const PopupMenuItem(
      value: 'remove',
      child: Row(
        children: [
          Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
          SizedBox(width: 8),
          Text("حذف العامل", style: TextStyle(fontSize: 14, color: AppColors.error, fontFamily: 'Cairo')),
        ],
      ),
    ),
  ];

  return AppBar(
    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    title: Text(
      'التفاصيل',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontFamily: 'Cairo',
      ),
    ),
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    actions: [
      PopupMenuButton<String>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(
          Icons.more_vert_rounded,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        onSelected: (x) {
          if (x == 'remove') {
            final userModel = User(id: user.id, name: user.name, job: user.job, salary: user.salary, isDeleted: 1);
            userViewModel.updateUser(userModel);
            Navigator.pop(context);
            showToast(context, 'تم حذف العامل ونقله الي خارج العمل', color: AppColors.error);
          } else {
            keyScaffold.currentState!.showBottomSheet(
              (context) => ChangeNotifierProvider.value(value: user, child: AddingUserBottomSheet(user: user)),
            );
          }
        },
        itemBuilder: (BuildContext context) => menuItems,
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
    ),
  );
}
