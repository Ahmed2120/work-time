import 'package:flutter/material.dart';
import 'package:work_time/views/components/functions.dart';

import '../core/utils/cache_helper.dart';
import 'bottom_nav_view.dart';
import 'components/constant.dart';
import 'purchase/components/purchase_data.dart';


class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {

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
                  CacheHelper.saveData(key: 'trial', value: true);
                  await showFlushBar(context);
                  trial=true;
                  pushReplacement(screen: BottomNavView(), context: context);
                }, label:Text('نسخة تجريبية',style: TextStyle(fontSize: 17),),icon: Icon(Icons.send_time_extension), )
              ],
            ),

          ),
        ),
      ),
    );
  }

}





