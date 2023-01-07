import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  const TextRow({required this.title,required this.txt,Key? key}) : super(key: key);
  final String title;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Text(
          "$title : ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          txt,
          style: const TextStyle(fontSize: 18),
        )
      ],
    );
  }
}
