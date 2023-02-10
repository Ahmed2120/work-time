import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cash_helper.dart';
import '../../service/api_service.dart';
import '../btm_bar_screen.dart';
import '../components/custom_textField.dart';
import '../users/components/functions.dart';

class PurchaseApp extends StatefulWidget {
   PurchaseApp({Key? key}) : super(key: key);

  @override
  State<PurchaseApp> createState() => _PurchaseAppState();
}

class _PurchaseAppState extends State<PurchaseApp> {
  final _formKey=GlobalKey<FormState>();

  final _emailController=TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Uri osamaPhone = Uri.parse('tel:+201094209343');
    final Uri osamaWhats = Uri.parse('whatsapp://send?phone=+201094209343');
    final Uri osamaFacebook =
        Uri.parse('https://m.me/send?id=100010839528124&mibextid=ZbWKwL');
    final Uri ahmedPhone = Uri.parse('tel:+201028038124');
    final Uri ahmedWhats = Uri.parse('whatsapp://send?phone=+201028038124');
    final Uri ahmedFacebook =
    Uri.parse('https://m.me/send?id=100007888419142&mibextid=ZbWKwL');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 29, 53, 87),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*.4,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/Logo.png',)
                        )
                    ),
                  ),
                  CustomTextField(controller: _emailController, label: 'الايميل',icon: const Icon(Icons.email,size: 30,color:Color(0xFF1d3557) ,),),
                  const SizedBox(height: 30),
                  isLoading ? const CircularProgressIndicator() : buildButton(context),
                  ],
              ),
            ),
            Spacer(),
            Text('تواصل معنا لشراء التطبيق'),
            Wrap(
              children: [
                Text('أحمد أشرف',style: TextStyle(fontSize: 15,color: Colors.grey[500],)),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    await launchUrl(ahmedWhats);
                  },
                  icon: Icon(FontAwesomeIcons.whatsapp,size: 20,),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () async {
                    await launchUrl(ahmedFacebook);
                  },
                  icon: Icon(
                    FontAwesomeIcons.facebookMessenger,
                    size: 20,
                    color: Color(0xC3A536FF),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await launchUrl(ahmedPhone);
                  },
                  icon: Icon(
                    FontAwesomeIcons.phone,
                    size: 15,
                  ),
                  color: Colors.blue,
                )
              ],
            ),
            Wrap(
              children: [
                Text('أسامة إبراهيم',style: TextStyle(fontSize: 15,color: Colors.grey[500],)),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    await launchUrl(osamaWhats);
                  },
                  icon: Icon(FontAwesomeIcons.whatsapp,size: 20,),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () async {
                    await launchUrl(osamaFacebook);
                  },
                  icon: Icon(
                    FontAwesomeIcons.facebookMessenger,
                    size: 20,
                    color: Color(0xC3A536FF),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await launchUrl(osamaPhone);
                  },
                  icon: Icon(
                    FontAwesomeIcons.phone,
                    size: 15,
                  ),
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget buildButton(context) => ElevatedButton(
    onPressed: () async{
      if (!_formKey.currentState!.validate()) return;
      setState(()=> isLoading = true);
      final api = ApiService();
      try{
        final bool isExist = await api.getUser(_emailController.text.trim());
        CashHelper.saveData(key: 'isExist', value: isExist);
        if(isExist) {
          pushReplacement(context: context, screen: const BottomBarScreen());
          CashHelper.saveData(key: 'trial', value: false);
          trial=false;
          showToast(context, 'تم الشراء بنجاح');
        }
        else{
          showMessageDialog(context, 'لا تستطيع الدخول بهذا الايميل');
        }
      }catch(e){
        final error = e.toString().replaceAll(RegExp("[Exception:]"), "");
        showMessageDialog(context, error);
        setState(()=> isLoading = false);
      }
      setState(()=> isLoading = false);
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1d3557),
        minimumSize: const Size(double.infinity, 10),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: const Text('شراء',
        style: TextStyle(
            color: Colors.white,
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
