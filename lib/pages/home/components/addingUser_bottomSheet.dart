import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/user.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/users/components/functions.dart';
import 'package:work_time/provider/attendance_provider.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../components/custom_textField.dart';
import '../../components/header_sheet.dart';

class AddingUserBottomSheet extends StatelessWidget {
  AddingUserBottomSheet(this.onPressed, {this.user,Key? key}) : super(key: key);

  final String onPressed;
  User? user;

  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _salaryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
   fillText();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SheetHeader(
            title: 'اضافة عامل',
          ),
          const SizedBox(
            height: 40
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'الاسم',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _jobController,
                    label: 'الوظيفة',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _salaryController,
                    label: 'الفئة',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildButton(context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(context) => ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          if (onPressed == 'add'){
          final userModel = User(
              name: _nameController.text,
              job: _jobController.text,
              salary: _salaryController.text);

            Provider.of<UserProvider>(context, listen: false).addUser(userModel);
            clearText();
            showToast(context, 'تم إضافة المستخدم بنجاح',);
          } else {
            final userModel = User(
              id: user!.id,
                name: _nameController.text,
                job: _jobController.text,
                salary: _salaryController.text,
              isDeleted: user!.isDeleted,
            );
            Provider.of<UserProvider>(context,listen: false).updateUser(userModel);
            showToast(context, 'تم تعديل البيانات بنجاح');
            clearText();
            pop(context);
          }
        },
        child: Text('اضافة',style: bootElevatedStyle,),
      );

  fillText(){
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
