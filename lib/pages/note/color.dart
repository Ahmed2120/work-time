import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/note_provider.dart';

class SwitchColor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final noteProvider=Provider.of<NoteProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('اختر لون العنوان',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        const SizedBox(width: 10),
        Row(
          children: [
            const Text('دفع',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 17),),
            Switch(
              inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red,
                value: noteProvider.color, onChanged: (newValue)=>noteProvider.changeColor(newValue)),
            const Text('استلام',style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
