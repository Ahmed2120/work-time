import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time/pages/btm_bar_screen.dart';
import 'package:work_time/pages/start_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';
import 'components/constant.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    showSplash(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
         width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/Logo.png'),fit: BoxFit.contain),
          ),
    ));
  }
}

Future<void> showSplash(context) async {
  Future.delayed(const Duration(milliseconds: 2500), () async {
    await isExistUser
        ? pushReplacement(context: context, screen: const LoginPage())
        : pushReplacement(context: context, screen: const StartPage());
  });
}

Future<bool>  get isExistUser async {
  final prefs = await SharedPreferences.getInstance();
  final bool? isExist = prefs.getBool('isExist');
  if(isExist == null || !isExist) {
    return false;
  } else {
    return true;
  }
}
