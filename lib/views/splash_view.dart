import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/views/start_view.dart';

import 'components/constant.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterSplash();
    });
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final bool userExists = await _isExistUser();
    if (!mounted) return;

    // ─── Play Store Mode ─────────────────────────────────────────────────────
    if (AppConfig.isPlayStore) {
      if (!userExists) {
        // First launch on Play Store starts in Trial mode automatically
        await CacheHelper.saveData(key: 'trial', value: true);
        trial = true;
      }
      pushReplacement(context: context, screen: const LoginView());
      return;
    }

    // ─── Standalone APK Mode (Freelance/Direct) ──────────────────────────────
    final bool isTrialActive = CacheHelper.getData(key: 'trial') == true || trial;
    if (userExists || isTrialActive) {
      pushReplacement(context: context, screen: const LoginView());
    } else {
      pushReplacement(context: context, screen: const StartView());
    }
  }

  Future<bool> _isExistUser() async {
    final bool? isExist = CacheHelper.getData(key: 'isExist');
    if (isExist == null || !isExist) {
      return false;
    } else {
      iSEXIST = true;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate — brand dark
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with dark background fills nicely on dark splash
            Image.asset(
              'assets/images/logo.png',
              width: 160,
              height: 160,
            ),
            const SizedBox(height: 24),
            const Text(
              'عُمَّالي',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة حضور وحسابات ويوميات العمال',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
