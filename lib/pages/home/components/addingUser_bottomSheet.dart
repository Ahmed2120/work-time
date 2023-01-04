import 'package:flutter/material.dart';

import '../../components/custom_textField.dart';
import '../../components/header_sheet.dart';

class AddingUserBottomSheet extends StatelessWidget {
  AddingUserBottomSheet({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height  * 0.8,
      child: Column(
        children: [
          const SheetHeader(title: 'اضافة عامل',),
          const SizedBox(height: 40,),
          Form(
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                    children: [
                      CustomTextField(controller: _nameController, label: 'الاسم',),
                      const SizedBox(height: 10,),
                      CustomTextField(controller: _nameController, label: 'الوظيفة',),
                      const SizedBox(height: 10,),
                      CustomTextField(controller: _nameController, label: 'الراتب',),
                      const SizedBox(height: 20,),
                      buildButton()
                    ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton()=> ElevatedButton(
    onPressed: (){},
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007C6D),
        minimumSize: const Size(double.infinity, 10),
        elevation: 0,
        textStyle:
        const TextStyle(fontSize: 20),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10))),
    child: const Text(
        'اضافة',
        style:TextStyle(color: Colors.white, )
    ),
  );
}