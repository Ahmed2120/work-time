import 'package:flutter/material.dart';

class CustomStatusText extends StatelessWidget {
  const CustomStatusText(this.title,{
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(color:  title == 'حاضر'
        ? Colors.green
        : Colors.red,),);
  }
}