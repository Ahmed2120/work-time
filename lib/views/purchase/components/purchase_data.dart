import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/data/services/api_service.dart';
import 'package:work_time/views/bottom_nav_view.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/components/functions.dart';

class PurchaseData extends StatefulWidget {
  const PurchaseData({super.key});

  @override
  State<PurchaseData> createState() => _PurchaseDataState();
}

class _PurchaseDataState extends State<PurchaseData> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ─── App Logo ───────────────────────────────────────────────
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEA580C).withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                'assets/images/transparent-logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Header Titles ──────────────────────────────────────────
          Text(
            'تفعيل ترخيص التطبيق',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'أدخل بريدك الإلكتروني المسجل لدينا للتحقق من شراء التطبيق وتفعيله',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // ─── Email Text Field ───────────────────────────────────────
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontFamily: 'Cairo',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'يرجى إدخال بريد إلكتروني صالح';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              hintText: 'user@example.com',
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.primaryPurple,
                size: 20,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─── Verify & Login Button ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 20, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          trial ? 'تفعيل الشراء' : 'التحقق وتسجيل الدخول',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final api = ApiService();
    try {
      final bool isExist = await api.getUser(_emailController.text.trim());
      await SecureStorageHelper.setUserExist(isExist);
      if (!mounted) return;

      if (isExist) {
        await SecureStorageHelper.setTrial(false);
        if (!mounted) return;
        pushReplacement(context: context, screen: const BottomNavView());
        showToast(context, 'تم تفعيل الترخيص بنجاح');
      } else {
        _showMessageDialog(context, 'هذا البريد غير مسجل كمشترك، يرجى شراء التطبيق أولاً.');
      }
    } catch (e) {
      final error = e.toString().replaceAll(RegExp(r"[Exception:]"), "").trim();
      _showMessageDialog(context, error.isNotEmpty ? error : 'تعذر الاتصال بالخادم');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('تنبيه', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo')),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
