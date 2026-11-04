import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/components/functions.dart';
import 'package:work_time/views/home/bulk_attendance/components/bulk_status_toggle.dart';
import 'package:work_time/views/home/bulk_attendance/components/employee_check_tile.dart';
import 'package:work_time/views/home/bulk_attendance/components/workplace_picker_sheet.dart';

class BulkAttendanceView extends StatefulWidget {
  const BulkAttendanceView({super.key});

  @override
  State<BulkAttendanceView> createState() => _BulkAttendanceViewState();
}

class _BulkAttendanceViewState extends State<BulkAttendanceView> {
  int _selectedStatus = 1; // 1 = حاضر, 0 = غائب
  Set<int> _selectedIds = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-select all employees by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final users = context.read<UserViewModel>().allUsers;
      setState(() {
        _selectedIds = users.where((u) => u.id != null).map((u) => u.id!).toSet();
      });
    });
  }

  bool get _allSelected {
    final users = context.read<UserViewModel>().allUsers;
    return users.isNotEmpty && users.every((u) => u.id != null && _selectedIds.contains(u.id));
  }

  void _toggleAll(List<User> users) {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds = users.where((u) => u.id != null).map((u) => u.id!).toSet();
      }
    });
  }

  Future<void> _submit() async {
    if (_selectedIds.isEmpty) {
      _showSnack('اختر موظفاً واحداً على الأقل', AppColors.warning);
      return;
    }

    final attendanceVM = context.read<AttendanceViewModel>();
    final bool isExpired = AppConfig.isPlayStore
        ? await SecureStorageHelper.isTrialExpired()
        : ((attendanceVM.attendanceUser.length) >= AppConfig.maxTrialAttendanceDays && trial);

    if (isExpired) {
      if (mounted) showFlushBar(context);
      return;
    }

    final allUsers = context.read<UserViewModel>().allUsers;
    final selectedUsers = allUsers.where((u) => u.id != null && _selectedIds.contains(u.id)).toList();

    String chosenPlace = 'لا يوجد';
    if (_selectedStatus == 1) {
      final workPlace = await showWorkplacePicker(context);
      if (!mounted) return;
      if (workPlace == null || workPlace.trim().isEmpty) return;
      chosenPlace = workPlace.trim();
    }

    setState(() => _isLoading = true);

    await attendanceVM.bulkAddAttendance(
      users: selectedUsers,
      status: _selectedStatus,
      workPlace: chosenPlace,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final statusLabel = _selectedStatus == 1 ? 'حاضر' : 'غائب';
    _showSnack(
      'تم تسجيل ${selectedUsers.length} عامل كـ $statusLabel بنجاح ✅',
      _selectedStatus == 1 ? AppColors.success : AppColors.danger,
    );

    Navigator.of(context).pop();
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final users = context.watch<UserViewModel>().allUsers;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'تسجيل تمام جماعي',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      body: Column(
        children: [
          // ─── Status Toggle ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر الحالة لتطبيقها على المحددين',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                BulkStatusToggle(
                  selectedStatus: _selectedStatus,
                  onChanged: (v) => setState(() => _selectedStatus = v),
                ),
              ],
            ),
          ),

          // ─── Select All + Count ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'العمال المحددين (${_selectedIds.length} من أصل ${users.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _toggleAll(users),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _allSelected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _allSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    child: Text(
                      _allSelected ? 'إلغاء تحديد الكل' : 'تحديد الكل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _allSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Employee List ──────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isChecked = user.id != null && _selectedIds.contains(user.id);
                return EmployeeCheckTile(
                  user: user,
                  isChecked: isChecked,
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        _selectedIds.add(user.id!);
                      } else {
                        _selectedIds.remove(user.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ─── Submit Bottom Bar ───────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(
                      _selectedStatus == 1 ? Icons.location_on_rounded : Icons.check_circle_rounded,
                      size: 20,
                    ),
              label: Text(
                _isLoading
                    ? 'جارٍ الحفظ...'
                    : (_selectedStatus == 1 ? 'اختيار مكان العمل وتأكيد الحضور' : 'تأكيد تسجيل الغياب'),
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedStatus == 1 ? AppColors.primary : AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
