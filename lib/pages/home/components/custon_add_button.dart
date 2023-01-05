import 'package:flutter/material.dart';

import 'addingUser_bottomSheet.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton(this.keyScaffold,{Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> keyScaffold;

  @override
  Widget build(BuildContext context) {
    print('we are here');
    return ElevatedButton(
      onPressed: () {
        keyScaffold.currentState!.showBottomSheet((context) => AddingUserBottomSheet());
        // showModalBottomSheet(
        //     enableDrag: true,
        //     isScrollControlled: true,
        //     isDismissible: false,
        //     context: context, builder: (context)=> AddingUserBottomSheet());
      },
      child: Row(
        children: const [
          Text('اضافة'),
          Icon(Icons.add)
        ],
      ),
    );
  }
}
