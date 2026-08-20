import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/global_methods.dart';
import 'package:work_time/view_models/backup_view_model.dart';
import 'package:work_time/view_models/note_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/components/app_button.dart';
import 'package:work_time/views/components/app_card.dart';

class BackupView extends StatefulWidget {
  const BackupView({super.key});

  @override
  State<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BackupViewModel>(context, listen: false).initGoogleAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Consumer<BackupViewModel>(
      builder: (context, backupVM, _) {
        final currentUser = backupVM.currentUser;
        final metadata = backupVM.backupMetadata;

        return Scaffold(
          appBar: AppBar(
            title: const Text('النسخ الاحتياطي السحابي'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, color: borderColor),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header Explanation Banner ──────────────────────────────────
                  AppCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.primaryLight,
                          ),
                          child: Icon(
                            Icons.cloud_sync_rounded,
                            size: 26,
                            color: isDark ? AppColors.indigoAccent : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'النسخ السحابي تلقائي وآمن',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'ربط حسابك بـ Google Drive لحفظ واستعادة بيانات العمال والتمام والملاحظات بسهولة (مثل WhatsApp)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Connected Google Account Card ──────────────────────────────
                  Text(
                    'حساب Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),

                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        if (currentUser != null) ...[
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primaryLight,
                                backgroundImage: currentUser.photoUrl != null
                                    ? NetworkImage(currentUser.photoUrl!)
                                    : null,
                                child: currentUser.photoUrl == null
                                    ? Text(
                                        currentUser.displayName?.isNotEmpty == true
                                            ? currentUser.displayName![0].toUpperCase()
                                            : 'G',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentUser.displayName ?? 'مستخدم Google',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    Text(
                                      currentUser.email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successBgLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_rounded, size: 12, color: AppColors.successText),
                                    SizedBox(width: 4),
                                    Text(
                                      'متصل',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.successText,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => backupVM.signOutGoogle(),
                              icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.dangerText),
                              label: const Text(
                                'تسجيل الخروج من الحساب',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.dangerText,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              const Icon(Icons.account_circle_outlined, size: 40, color: Color(0xFF64748B)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'غير متصل بحساب Google',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    Text(
                                      'سجل الدخول لحفظ نسخة احتياطية على سحابة Google',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AppButton(
                            label: 'تسجيل الدخول بـ Google',
                            icon: Icons.g_mobiledata_rounded,
                            style: AppButtonStyle.secondary,
                            onPressed: () => backupVM.signInGoogle(),
                            isLoading: backupVM.isSigningIn,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (backupVM.signInError.isNotEmpty) ...[
                    Text(
                      backupVM.signInError,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ─── Cloud Backup Details Card ───────────────────────────────────
                  Text(
                    'حالة النسخة الاحتياطية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),

                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 20,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'آخر نسخة سحابية:',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              metadata != null
                                  ? '${GlobalMethods.getDayName(metadata.modifiedTime)}، ${GlobalMethods.getDateFormat(metadata.modifiedTime)}'
                                  : 'لا توجد نسخة سحابية',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                        if (metadata != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.data_usage_rounded,
                                size: 20,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'حجم البيانات:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatFileSize(metadata.sizeBytes),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // ─── Weekly Auto Sync Row ───────────────────────────────────
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: backupVM.isAutoSyncEnabled
                                    ? (isDark ? AppColors.darkSurface : AppColors.lightAmber)
                                    : (isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.sync_rounded,
                                size: 20,
                                color: backupVM.isAutoSyncEnabled
                                    ? AppColors.primaryAmber
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المزامنة الأسبوعية التلقائية',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Text(
                                    backupVM.lastAutoSyncTime != null
                                        ? 'آخر مزامنة: ${GlobalMethods.getDateFormat(backupVM.lastAutoSyncTime!)}'
                                        : 'مزامنة صامتة في الخلفية كل 7 أيام',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: backupVM.isAutoSyncEnabled,
                              activeTrackColor: AppColors.primaryAmber,
                              activeThumbColor: Colors.white,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFCBD5E1),
                              onChanged: (val) => backupVM.toggleAutoSync(val),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Backup Action ──────────────────────────────────────────────
                  if (backupVM.isUploading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            SizedBox(height: 12),
                            Text(
                              'جاري رفع النسخة الاحتياطية إلى Google Drive...',
                              style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    AppButton(
                      label: 'نسخ إحتياطي الآن (Google Drive)',
                      icon: Icons.cloud_upload_rounded,
                      style: AppButtonStyle.primary,
                      onPressed: () => backupVM.performBackup(context),
                    ),

                  const SizedBox(height: 12),

                  // ─── Restore Action ──────────────────────────────────────────────
                  if (backupVM.isRestoring)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            SizedBox(height: 12),
                            Text(
                              'جاري استعادة البيانات من Google Drive...',
                              style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    AppButton(
                      label: 'استعادة النسخة الاحتياطية',
                      icon: Icons.cloud_download_rounded,
                      style: AppButtonStyle.secondary,
                      onPressed: () => _confirmRestoreDialog(context, backupVM),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmRestoreDialog(BuildContext context, BackupViewModel backupVM) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warningText, size: 28),
            SizedBox(width: 8),
            Text(
              'تأكيد استعادة البيانات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ],
        ),
        content: const Text(
          'سيتم استبدال البيانات الحالية بالنسخة المخزنة على Google Drive. هل تريد الاستمرار؟',
          style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              backupVM.performRestore(
                context,
                onSuccess: () {
                  // Reload ViewModels
                  Provider.of<UserViewModel>(context, listen: false).getUsers();
                  Provider.of<NoteViewModel>(context, listen: false).getNotes();
                },
              );
            },
            child: const Text('استعادة الآن', style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
