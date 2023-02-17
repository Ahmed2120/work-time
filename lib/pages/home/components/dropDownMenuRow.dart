import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/Theme/theme.dart';
import 'package:work_time/provider/user_provider.dart';


class DropDownMenuRow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userProvider=Provider.of<UserProvider>(context, listen: true);
    return Row(
      children: [
         Text('الفئة',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: defaultColor),),
        const SizedBox(width: 10,),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              value: userProvider.dropDownValue,
              icon: const Icon(
                Icons.filter_alt,
                color: Color(0xFFE94560),
                size: 22,
              ),
              dropdownColor: Colors.white,
              alignment: Alignment.topRight,
              items: Provider.of<UserProvider>(context, listen: false).filteredUsers.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        color: Color(0xFF533483)),
                  ),
                );
              }).toList(),
              onChanged: (val){
                userProvider.getUsers().then((value) {
                  userProvider.dropDownChane(val!);
                });

              } ),
        ),
      ],
    );
  }
}
