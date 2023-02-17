import 'package:flutter/material.dart';

class HeaderSheet extends StatelessWidget {
  const HeaderSheet({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      color: const Color(0xFF0F3460),
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge
          ),
          const Spacer(),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close))
        ],
      ),
    );
  }
}