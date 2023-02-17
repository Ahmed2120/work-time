import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/note.dart';
import '../../../provider/note_provider.dart';
import '../../../utility/global_methods.dart';
import '../../components/constant.dart';
import 'note_editor.dart';

class ItemNote extends StatelessWidget {
  const ItemNote({required this.note,Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
          color: const Color(0xFFF7F7F7),
          child:ListTile(
            onTap: (){
              push(screen:  NoteEditor(note: note,), context: context);
            },
            title: Text(note.title,style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: note.color==1?const Color(0xFF0F3460):const Color(0xFFE94560)),overflow: TextOverflow.ellipsis,),
            subtitle:  Text("${GlobalMethods.getDayName(DateTime.parse(note.dateCreated))}  ${GlobalMethods.getDateFormat(DateTime.parse(note.dateCreated))}",style: const TextStyle(color: Color(0xFF0F3460),fontSize: 14),),
            trailing: IconButton(icon: const Icon(Icons.delete_outline,color: Color(0xFFCB1718),), onPressed: () { Provider.of<NoteProvider>(context,listen: false).deleteNote(note); },),
          )
      ),
    );
  }
}
