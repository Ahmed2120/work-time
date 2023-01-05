import 'package:flutter/material.dart';

import 'addingUser_bottomSheet.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('we are here');
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            isDismissible: false,
            context: context, builder: (context)=> AddingUserBottomSheet());
      },
      child: Row(
        children: [
          Text('اضافة'),
          Icon(Icons.add)
        ],
      ),
    );
  }
}
