import 'package:flutter/material.dart';

import 'pages/btm_bar_screen.dart';
import 'service/local_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginFinger();
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
                      image: AssetImage('assets/images/Logo.png',)
                  )
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(onPressed: (){
              loginFinger();
            },  child: Text('📲  تسجيل دخــول',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),),
          )
        ],
      ),
    );
  }
  void loginFinger()async{
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomBarScreen()),
      );
    }
  }
}