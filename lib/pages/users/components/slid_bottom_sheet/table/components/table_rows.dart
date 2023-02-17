import 'package:flutter/material.dart';

class TableRows extends StatelessWidget {
  const TableRows(this.txt, this.padding, {Key? key}) : super(key: key);

  final String txt;
  final double padding;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        txt, textAlign: TextAlign.center, style: TextStyle(fontSize: 9),),
    );
  }
}