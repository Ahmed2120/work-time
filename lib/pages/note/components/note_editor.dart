import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/components/functions.dart';
import 'package:work_time/provider/note_provider.dart';

import '../../../model/note.dart';
import 'title_color.dart';

class NoteEditor extends StatelessWidget {
  NoteEditor({this.note, Key? key}) : super(key: key);

  Note? note;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fillText();
    return Consumer<NoteProvider>(
      builder: (ctx, noteProvider, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title:  Text(note==null?'إضافة ملاحظات جديدة':'تعديل ملاحظات'),
            actions: [
              IconButton(
                  onPressed: () {
                    if (note == null) {
                      if (_titleController.text.isEmpty &&
                          _descriptionController.text.isEmpty) {
                        noteProvider.addNote(Note(
                          title: 'بدون عنوان',
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      } else if (_titleController.text.isEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        final List<String> lines =
                        _descriptionController.text.split('\n');
                        noteProvider.addNote(Note(
                          title: lines[0],
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      } else {
                        noteProvider.addNote(Note(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      }
                      showToast(context, 'تم حفظ الملاحظات');
                      pop(context);
                    } else {
                      if (_titleController.text.isEmpty &&
                          _descriptionController.text.isEmpty) {
                        noteProvider.updateNote(Note(
                          id: note!.id,
                          title: 'بدون عنوان',
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      } else if (_titleController.text.isEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        final List<String> lines =
                        _descriptionController.text.split('\n');
                        noteProvider.updateNote(Note(
                          id: note!.id,
                          title: lines[0],
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      } else {
                        noteProvider.updateNote(Note(
                          id: note!.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dateCreated: '${DateTime.now()}', color: noteProvider.colorVal,
                        ));
                      }
                      showToast(context, 'تم تعديل الملاحظات');
                      pop(context);
                    }
                  },
                  icon: const Icon(Icons.save))
            ],
          ),
          body: buildPadding(context),
        );
      },
    );
  }

  Padding buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: ListView(
        children: [
          SwitchColor(),
          TextField(
            controller: _titleController,
            style:Theme.of(context).textTheme.bodyLarge,
            decoration:
                const InputDecoration(hintText: 'العنوان', labelText: 'العنوان'),
          ),
          TextField(
            controller: _descriptionController,
            maxLines: 20,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'الوصف',
            ),
          )
        ],
      ),
    );
  }

  fillText(){
    if(note!=null){
      _titleController.text=note!.title;
      _descriptionController.text=note!.description;
    }
  }

  clearText(){
    _titleController.clear();
    _descriptionController.clear();
  }
}
