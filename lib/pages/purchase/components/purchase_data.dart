import 'package:flutter/material.dart';

import '../../../cash_helper.dart';
import '../../../service/api_service.dart';
import '../../btm_bar_screen.dart';
import '../../components/constant.dart';
import '../../components/custom_textField.dart';
import '../../components/functions.dart';

class PurchaseData extends StatefulWidget {
   PurchaseData({Key? key}) : super(key: key);

  @override
  State<PurchaseData> createState() => _PurchaseDataState();
}

class _PurchaseDataState extends State<PurchaseData> {
  final _formKey=GlobalKey<FormState>();

  final _emailController=TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
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
    child:  Text('${trial? 'شراء':'دخول'}',
        style: Theme.of(context).textTheme.bodyLarge),
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
