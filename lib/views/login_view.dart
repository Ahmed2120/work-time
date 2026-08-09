import 'package:flutter/material.dart';

import 'package:work_time/data/services/local_auth_service.dart';

import 'bottom_nav_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Defer until after the first frame is rendered to avoid black screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginFinger();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/Logo.png'),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                loginFinger();
              },
              child: const Text(
                '📲  تسجيل دخــول',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  void loginFinger() async {
    final bool canAuth = await LocalAuthApi.hasBiometrics();

    if (!mounted) return;

    if (!canAuth) {
      // Small delay so the login screen renders before navigating
      await Future.delayed(const Duration(milliseconds: 300));
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
  }
}
