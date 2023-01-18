import 'package:flutter/material.dart';

class CustomStatusText extends StatelessWidget {
  const CustomStatusText(this.title,{
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: getColor(title),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [BoxShadow(
            blurRadius: 1
          )]
        ),
        child: Center(
          child: Text(title,
            style: const TextStyle(color:  Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }
  getColor(title){
    if(title == 'حاضر') {
      return const Color(0xFF33D448);
    } else if(title == 'غائب') {
      return const Color(0xFFE8110F);
    } else {
      return const Color(0xFCAFAAAA);
    }

  }
}