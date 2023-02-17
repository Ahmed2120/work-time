import 'package:flutter/material.dart';

class ButtonAttendance extends StatelessWidget {
  const ButtonAttendance({required this.color,required this.label,required this.onPressed,Key? key}) : super(key: key);

 final String label;
       final Color color;
     final  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label,style: const TextStyle(color: Colors.white,fontSize: 17),),
    );
  }
}
