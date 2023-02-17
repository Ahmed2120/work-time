import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {

  const TableHeader(this.txt,{Key? key}) : super(key: key);
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        txt,
        style: const TextStyle(
            fontSize: 11, color: Color(0xFF084081), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
