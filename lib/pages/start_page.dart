import 'package:flutter/material.dart';

import '../service/api_service.dart';
import 'btm_bar_screen.dart';
import 'components/constant.dart';
import 'components/custom_textField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(controller: _emailController, label: 'الايميل',),
                const SizedBox(height: 30,),
                isLoading ? const CircularProgressIndicator() : buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(context) => ElevatedButton(
    onPressed: () async{
      if (!_formKey.currentState!.validate()) return;
      setState(()=> isLoading = true);
      final api = ApiService();
      final bool isExist = await api.getUser(_emailController.text.trim());
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isExist', isExist);
      if(isExist) {
            push(context: context, screen: const BottomBarScreen());
          }
      else{
        showMessageDialog(context, 'لا تستطيع الدخول بهذا الايميل');
      }
          setState(()=> isLoading = false);
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF9BBB0),
        minimumSize: const Size(double.infinity, 10),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: const Text('ابدا',
        style: TextStyle(
            color: Color(0xFF16213E),
            fontSize: 22,
            fontWeight: FontWeight.bold
        )),
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