import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/custom_textField.dart';
import 'package:work_time/provider/note_provider.dart';
import 'package:work_time/utility/global_methods.dart';

import '../../cash_helper.dart';
import '../EmptyScreen/epmty_screen.dart';
import '../components/constant.dart';
import '../components/functions.dart';
import 'components/item_note.dart';
import 'components/note_editor.dart';
import 'components/search_note.dart';

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
           physics: BouncingScrollPhysics(),
           children: [
              Padding(
               padding: const EdgeInsets.only(top: 20.0,bottom: 15,right: 20,left: 20),
               child: SearchNote(controller: _searchController)
             ),
            if(notes.isEmpty)EmptyScreen(title:'قائمة الملاحظلات فاغة \n أضف بعض الملاحظات'),
              ...notes.map((note) =>ItemNote(note: note,)).toList()
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
