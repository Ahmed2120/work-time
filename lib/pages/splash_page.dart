import 'package:flutter/material.dart';
import 'package:work_time/cash_helper.dart';
import 'package:work_time/pages/start_page.dart';


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
    if(await isExistUser || trial)
        { pushReplacement(context: context, screen: const LoginPage());}
    else{ pushReplacement(context: context, screen: const StartPage());}
  });
}

Future<bool>  get isExistUser async {
  final bool? isExist = CashHelper.getData(key: 'isExist');
  if(isExist == null || !isExist) {
    return false;
  } else {
    iSEXIST = true;
    return true;
  }
}
