import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time/pages/btm_bar_screen.dart';
import 'package:work_time/pages/start_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
          padding: const EdgeInsets.only(right: 25),
      decoration: const BoxDecoration(
       color: Colors.white
          ),
      child: Center(child: Image.asset('assets/images/Logo.png',fit: BoxFit.cover,)),
    ));
  }
}

Future<void> showSplash(context) async {
  Future.delayed(const Duration(milliseconds: 2500), () async {
    await isExistUser
        ? pushReplacement(context: context, screen: const BottomBarScreen())
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
