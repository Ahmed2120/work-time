import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/home/components/balance/worker_balance_share_sheet.dart';

import '../../../data/models/user.dart';
import '../../../view_models/user_view_model.dart';
import '../../components/functions.dart';
import '../../home/components/bottom_sheet/addingUser_bottomSheet.dart';

AppBar appBar(UserViewModel userViewModel, BuildContext context, User user, GlobalKey<ScaffoldState> keyScaffold) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final List<PopupMenuItem<String>> menuItems = [
    PopupMenuItem(
      value: 'add',
      child: Row(
        children: [
          const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryPurple),
          const SizedBox(width: 8),
          Text(context.l10n.editWorker, style: const TextStyle(fontSize: 14, fontFamily: 'Cairo')),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'remove',
      child: Row(
        children: [
          const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
          const SizedBox(width: 8),
          Text(context.l10n.deleteWorker, style: const TextStyle(fontSize: 14, color: AppColors.error, fontFamily: 'Cairo')),
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
      context.l10n.details,
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
      IconButton(
        icon: Icon(
          Icons.share_outlined,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        tooltip: context.l10n.shareStatement,
        onPressed: () async {
          final reportsVM = Provider.of<ReportsViewModel>(context, listen: false);
          final report = await reportsVM.getWorkerReport(user: user);
          if (!context.mounted) return;
          final arabicMonths = [
            'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
            'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
          ];
          final englishMonths = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          final m = reportsVM.selectedMonth.month;
          final monthName = context.isArabic ? arabicMonths[m - 1] : englishMonths[m - 1];
          final monthTitle = '$monthName ${reportsVM.selectedMonth.year}';

          WorkerBalanceShareSheet.show(
            context,
            report: report,
            monthTitle: monthTitle,
            currency: context.currencyRead,
          );
        },
      ),
      PopupMenuButton<String>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(
          Icons.more_vert_rounded,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        onSelected: (x) {
          if (x == 'remove') {
            final userModel = User(id: user.id, name: user.name, job: user.job, salary: user.salary, isDeleted: 1, defaultDayRatio: user.defaultDayRatio);
            userViewModel.updateUser(userModel);
            Navigator.pop(context);
            showToast(context, context.l10n.workerMovedToOutOfWork, color: AppColors.error);
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
