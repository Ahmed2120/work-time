import 'package:flutter/material.dart';

void push({required Widget screen,required BuildContext context}){
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>screen));
}

void pushReplacement({required Widget screen,required BuildContext context}){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>screen));
}
void pop(BuildContext context){
  Navigator.of(context).pop();
}

TextStyle bootElevatedStyle= TextStyle(fontSize: 22,color: Color(0xFF16213E),fontWeight: FontWeight.bold);

bool ISEXIST = false;