import 'package:flutter/material.dart';

class CustomStatusText extends StatelessWidget {
  const CustomStatusText(this.title,{
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(color:  getColor(title), fontSize: 20, fontWeight: FontWeight.w700),);
  }

  getColor(title){
    if(title == 'حاضر') {
      return Colors.green;
    } else if(title == 'غائب') {
      return Colors.red;
    } else {
      return Colors.grey;
    }

  }
}