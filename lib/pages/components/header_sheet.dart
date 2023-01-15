import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({required this.title, Key? key}) : super(key: key);
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
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white70),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(5),
            decoration:const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE94560)
            ),
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close,size: 20,color: Color(0xFF533483),)),
          )
        ],
      ),
    );
  }
}