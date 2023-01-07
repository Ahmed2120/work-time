import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  BuildCard(this.widget,{Key? key}) : super(key: key);
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget,
      ),
    );
  }
}
