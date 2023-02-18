import 'package:flutter/material.dart';
import 'package:work_time/pages/components/constant.dart';

import '../../Theme/theme.dart';
import 'components/ahmed_ashraf.dart';
import 'components/purchase_data.dart';
import 'components/osama_ibrahim.dart';

class PurchaseApp extends StatelessWidget {
   PurchaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
final orientation=MediaQuery.of(context).orientation;
final isOrientation=orientation==Orientation.landscape;
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
            color:defaultColor
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:!isOrientation? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PurchaseData(),
            Spacer(),
            Text('تواصل معنا لشراء التطبيق'),
            SizedBox(height: 10),
            AhmedAshraf(),
            OsamaIbrahim(),
            SizedBox(height: 10)
          ],
        ):ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            PurchaseData(),
            SizedBox(height: 50),
            Text('تواصل معنا لشراء التطبيق'),
            SizedBox(height: 10),
            AhmedAshraf(),
            OsamaIbrahim(),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }


}
