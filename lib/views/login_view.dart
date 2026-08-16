import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/services/local_auth_service.dart';

import 'bottom_nav_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric prompt after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginFinger();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ─── App Logo ─────────────────────────────────────────────
                Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/Logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Welcome Header ────────────────────────────────────────
                Text(
                  'مرحباً بك مجدداً',
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
                  'يرجى المصادقة بالبصمة أو رمز القفل للوصول إلى بيانات العمل',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ─── Biometric Fingerprint Icon Card ───────────────────────
                InkWell(
                  onTap: _isAuthenticating ? null : loginFinger,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primaryPurple.withValues(alpha: 0.15)
                          : AppColors.lightPurple,
                      border: Border.all(
                        color: AppColors.primaryPurple.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fingerprint_rounded,
                        size: 64,
                        color: _isAuthenticating
                            ? AppColors.primaryPurple.withValues(alpha: 0.5)
                            : AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // ─── Unlock Button ────────────────────────────────────────
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
                    onPressed: _isAuthenticating ? null : loginFinger,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_open_rounded, size: 20, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          _isAuthenticating ? 'جاري التحقق...' : 'فتح التطبيق بالبصمة',
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

                const SizedBox(height: 14),

                // ─── Trial Mode Button ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPurple,
                      side: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const BottomNavView()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_outline_rounded, size: 18, color: AppColors.primaryPurple),
                        SizedBox(width: 8),
                        Text(
                          'نسخة تجريبية',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginFinger() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    try {
      final bool canAuth = await LocalAuthApi.hasBiometrics();

      if (!mounted) return;

      if (!canAuth) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavView()),
        );
        return;
      }

      final isAuthenticated = await LocalAuthApi.authenticate();
      if (!mounted) return;

      if (isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavView()),
        );
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }
}
