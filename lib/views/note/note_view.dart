import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/note_view_model.dart';

import '../../core/utils/cache_helper.dart';
import '../EmptyScreen/empty_screen.dart';
import '../components/constant.dart';
import '../components/functions.dart';
import 'components/item_note.dart';
import 'components/note_editor.dart';
import 'components/search_note.dart';

class NoteView extends StatelessWidget {
  NoteView({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<NoteViewModel>(
      builder: (ctx, noteViewModel, _) {
        final notes = noteViewModel.notes;
        return Scaffold(
          appBar: AppBar(
            title: const Text('الملاحظات'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchNote(controller: _searchController),
              ),
              if (notes.isEmpty)
                const EmptyScreen(title: 'لا توجد ملاحظات، أضف ملاحظة جديدة'),
              ...notes.map((note) => ItemNote(note: note)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            onPressed: () {
              if ((noteViewModel.notes.length) >= 5 && trial) {
                showFlushBar(context);
              } else {
                push(screen: NoteEditor(), context: context);
              }
            },
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'إضافة ملاحظة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );
      },
    );
  }
}
