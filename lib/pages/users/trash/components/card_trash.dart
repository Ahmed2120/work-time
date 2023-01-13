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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    //final userModel=
                    userProvider.deleteUser(user);
                  }, icon: const Icon(Icons.delete,color: Colors.red,)),
                  IconButton(onPressed: (){
                    final userModel=User(id: user.id,name: user.name, job: user.job, salary: user.salary,isDeleted: 0);
                    userProvider.updateUser(userModel);
                  }, icon: const Icon(Icons.restore,color: Colors.green,)),
                ],
              ),
              Text(user.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ],),
        ),
      ),
    );
  }
}
