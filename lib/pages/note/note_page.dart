import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/custom_textField.dart';
import 'package:work_time/provider/note_provider.dart';
import 'package:work_time/utility/global_methods.dart';

import '../../cash_helper.dart';
import '../EmptyScreen/epmty_screen.dart';
import '../components/constant.dart';
import '../users/components/functions.dart';
import 'note_editor.dart';
import 'search_note.dart';

class NotePage extends StatelessWidget {
   NotePage({Key? key}) : super(key: key);

  final _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (ctx,noteProvider,_) {
        final notes=noteProvider.notes;
       return Scaffold(
         appBar: AppBar(
           title: const Text("الملاحظات"),
           centerTitle: true,
         ),
         body: ListView(
           children: [
              Padding(
               padding: const EdgeInsets.only(top: 20.0,bottom: 15,right: 20,left: 20),
               child: SearchNote(controller: _searchController)
             ),
            if(notes.isEmpty)EmptyScreen(title:'قائمة الملاحظلات فاغة \n أضف بعض الملاحظات'),
              ...notes.map((note) =>Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Card(
                   color: const Color(0xFFF7F7F7),
                   child:ListTile(
                     onTap: (){
                       push(screen:  NoteEditor(note: note,), context: context);
                     },
                     title: Text(note.title,style:  TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: note.color==1?const Color(0xFF0F3460):const Color(0xFFE94560)),overflow: TextOverflow.ellipsis,),
                     subtitle:  Text("${GlobalMethods.getDayName(DateTime.parse(note.dateCreated))}  ${GlobalMethods.getDateFormat(DateTime.parse(note.dateCreated))}",style: const TextStyle(color: Color(0xFF0F3460),fontSize: 14),),
                     trailing: IconButton(icon: const Icon(Icons.delete_outline,color: Color(0xFFCB1718),), onPressed: () { noteProvider.deleteNote(note); },),
                   )
               ),
             )).toList()
           ],
         ),
         floatingActionButton: FloatingActionButton(
           backgroundColor: const Color(0xFF533483),
           onPressed: (){
             if((noteProvider.notes.length)>=5&&trial) {
               showFlushBar(context);
             }else{
               push(screen:  NoteEditor(), context: context);
             }

         },child: const Icon(Icons.note_alt_outlined,size: 28,),),
       );
      }
    );
  }
}
