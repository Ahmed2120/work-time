import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/user.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/users/components/functions.dart';
import 'package:work_time/provider/attendance_provider.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../components/custom_textField.dart';
import '../../components/header_sheet.dart';

class EditUserBottomSheet extends StatelessWidget {
  EditUserBottomSheet(this.onPressed, {Key? key}) : super(key: key);

  final String onPressed;

  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _salaryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    fillText(user);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SheetHeader(title: 'تعديل عامل'),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'الاسم'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _jobController,
                    label: 'الوظيفة'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _salaryController,
                    label: 'الراتب',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  buildButton(context, user)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(context, user) => ElevatedButton(
    onPressed: () {
      if (!_formKey.currentState!.validate()) return;
      user.name = _nameController.text;
      user.job = _jobController.text;
      user.salary = _salaryController.text;
      Provider.of<UserProvider>(context,listen: false).updateUser(user);
      showToast(context, 'تم تعديل البيانات بنجاح');
      clearText();
      pop(context);
    },
    child: Text('تعديل',style: bootElevatedStyle,),
  );

  fillText(user){
    if(user!=null){
      _nameController.text=user!.name;
      _salaryController.text=user!.salary;
      _jobController.text=user!.job;
    }
  }

  clearText(){
    _nameController.clear();
    _salaryController.clear();
    _jobController.clear();
  }
}
