import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/user.dart';
import '../../../../provider/user_provider.dart';

class CustomCardTrash extends StatelessWidget {
  const CustomCardTrash(this.user,{Key? key}) : super(key: key);
final User user;
  @override
  Widget build(BuildContext context) {
    final userProvider=Provider.of<UserProvider>(context);
    return Card(
      color: const Color(0xF5F5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(user.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Row(
              children: [
                 IconButton(onPressed: (){
                  final userModel=User(id: user.id,name: user.name, job: user.job, salary: user.salary,isDeleted: 0);
                  userProvider.updateUser(userModel);
                }, icon: const Icon(Icons.restore,color: Colors.green,)),
                IconButton(onPressed: (){
                  //final userModel=
                  userProvider.deleteUser(user);
                }, icon: const Icon(Icons.delete_outline,color: Colors.red,)),
              ],
            ),
          ],),
      ),
    );
  }
}
