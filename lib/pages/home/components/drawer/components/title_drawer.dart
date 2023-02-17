import 'package:flutter/material.dart';

class TitleDrawer extends StatelessWidget {
  const TitleDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Text(
            'WorkTime',
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
        ),
        color: const Color(0xFF16213E)
    );
  }
}
