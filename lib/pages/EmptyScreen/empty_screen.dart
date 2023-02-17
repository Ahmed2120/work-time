import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({required this.title,Key? key}) : super(key: key);
final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*.4,
            width: double.infinity,
            decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/noData.PNG'),fit: BoxFit.fill)
          ),
          ),
          SizedBox(height: 30),
          Text('لا توجد بيانات \n $title',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800,color: Colors.grey),textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
