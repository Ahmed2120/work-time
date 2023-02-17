import 'package:flutter/material.dart';
import 'package:work_time/pages/components/functions.dart';

import '../cash_helper.dart';
import 'btm_bar_screen.dart';
import 'components/constant.dart';
import 'purchase/components/purchase_data.dart';


class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PurchaseData(),
                const SizedBox(height: 30),
                OutlinedButton.icon(onPressed: ()async{
                  CashHelper.saveData(key: 'trial', value: true);
                  await showFlushBar(context);
                  trial=true;
                  pushReplacement(screen: BottomBarScreen(), context: context);
                }, label:Text('نسخة تجريبية',style: TextStyle(fontSize: 17,color: Colors.blue),),icon: Icon(Icons.send_time_extension), )
              ],
            ),

          ),
        ),
      ),
    );
  }

}