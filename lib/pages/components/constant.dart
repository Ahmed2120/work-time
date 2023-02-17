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