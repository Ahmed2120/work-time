import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/note_provider.dart';
class SearchNote extends StatelessWidget {
  const SearchNote({super.key, required TextEditingController controller,})
      : _searchController = controller;

  final TextEditingController _searchController;
  @override
  Widget build(BuildContext context) {
    return  TextField(
      style: const TextStyle(color: Colors.black),
      controller: _searchController,
      onChanged: (txt){
        if(txt.isEmpty){
          Provider.of<NoteProvider>(context,listen: false).getNotes();
        }
        else{
          Provider.of<NoteProvider>(context,listen: false).searchNote(txt);
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded,size: 35,color: Colors.grey,),
            hintText: 'بحث في الملاحظات',
        hintStyle: const TextStyle(fontSize: 18),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(40)),
      ),
    );
  }
}
