import 'package:flutter/material.dart';

import '../../Theme/theme.dart';

class Steps extends StatelessWidget {
  const Steps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3, color: const Color(0xFF315fbb))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('خطوات استرجاع النسخة الاحتياطية',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: defaultColor),
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            Text('1 تحميل الملف من جوجل دريف '),
            Text('2 نسخ الملف في المسار المحدد '),
            Text('3 المسار \n storage/emulated/0/WorkTime/dgi.db '),
            Text('4 الضغط علي استرجاع النسخة الاحتياطية '),
          ],
        ));
  }
}
