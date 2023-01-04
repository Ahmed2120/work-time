import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        color: Colors.red,
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.grey),
            ),
            const Spacer(),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, size: 30,))
          ],
        ),
      ),
    );
  }
}