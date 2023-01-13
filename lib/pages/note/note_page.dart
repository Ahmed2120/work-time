import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/note_provider.dart';
import 'package:work_time/utility/global_methods.dart';

import '../components/constant.dart';
import 'note_editor.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (ctx,noteProvider,_) {
        final notes=noteProvider.notes;
       return Scaffold(
         appBar: AppBar(
           title: const Text("الملاحظات"),
         ),
         body: ListView.builder(itemBuilder: (ctx,index)=> Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Card(
                 child:Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: InkWell(
                           onTap: (){
                             push(screen:  NoteEditor(
                               note: notes[index],
                             ), context: context);
                           },
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                 Text(notes[index].title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                               Text(GlobalMethods.getDateFormat(DateTime.parse(notes[index].dateCreated)),style: const TextStyle(fontSize: 12,color: Colors.grey),)
                             ],
                           )
                       ),
                     ),
                     IconButton(onPressed: (){
                       noteProvider.deleteNote(notes[index]);
                     }, icon: const Icon(Icons.delete_outline,color: Colors.red,))
                   ],
                 )
             ),
           ),
           itemCount: notes.length,
         ),
         floatingActionButton: FloatingActionButton(onPressed: (){
           push(screen:  NoteEditor(), context: context);
         },child: const Icon(Icons.note_alt_outlined),),
       );
      }
    );
  }
}
