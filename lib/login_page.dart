import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/components/custom_textField.dart';
import 'pages/home/home_page.dart';
import 'service/local_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*.5,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Logo.png',)
                        )
                    ),
                  ),
                  CustomTextField(controller: _emailController, label: 'الايميل',icon: const Icon(Icons.email,size: 30,color:Color(0xFF1d3557) ,),),
                  CustomTextField(controller: _emailController, label: 'الباسورد',icon: const Icon(Icons.lock,size: 30,color:Color(0xFF1d3557) ,),),
                  const SizedBox(height: 30),
                  isLoading ? const CircularProgressIndicator() : buildButton(context)
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }

  Widget buildButton(context) => ElevatedButton(
    onPressed: () async{

      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1d3557),
        minimumSize: const Size(double.infinity, 10),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: const Text('ابدا',
        style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold
        )),
  );

  Widget buildText(String text, bool checked) => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        checked
            ? Icon(Icons.check, color: Colors.green, size: 24)
            : Icon(Icons.close, color: Colors.red, size: 24),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 24)),
      ],
    ),
  );

  void showMessageDialog(BuildContext context,String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('حدث خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('تم'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}