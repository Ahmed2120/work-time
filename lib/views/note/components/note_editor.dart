import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/note.dart';
import 'package:work_time/view_models/note_view_model.dart';
import 'package:work_time/views/components/app_button.dart';

import 'package:work_time/views/components/functions.dart';

import 'title_color.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  const NoteEditor({this.note, super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController = TextEditingController(text: widget.note?.description ?? '');

    if (widget.note != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<NoteViewModel>(context, listen: false).setColorVal(widget.note!.color);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote(NoteViewModel noteViewModel) {
    if (widget.note == null) {
      if (_titleController.text.isEmpty && _descriptionController.text.isEmpty) {
        noteViewModel.addNote(Note(
          title: 'بدون عنوان',
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      } else if (_titleController.text.isEmpty && _descriptionController.text.isNotEmpty) {
        final List<String> lines = _descriptionController.text.split('\n');
        noteViewModel.addNote(Note(
          title: lines[0],
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      } else {
        noteViewModel.addNote(Note(
          title: _titleController.text,
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      }
      showToast(context, 'تم حفظ الملاحظة بنجاح');
      Navigator.of(context).pop();
    } else {
      if (_titleController.text.isEmpty && _descriptionController.text.isEmpty) {
        noteViewModel.updateNote(Note(
          id: widget.note!.id,
          title: 'بدون عنوان',
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      } else if (_titleController.text.isEmpty && _descriptionController.text.isNotEmpty) {
        final List<String> lines = _descriptionController.text.split('\n');
        noteViewModel.updateNote(Note(
          id: widget.note!.id,
          title: lines[0],
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      } else {
        noteViewModel.updateNote(Note(
          id: widget.note!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dateCreated: '${DateTime.now()}',
          color: noteViewModel.colorVal,
        ));
      }
      showToast(context, 'تم تعديل الملاحظة بنجاح');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Consumer<NoteViewModel>(
      builder: (ctx, noteViewModel, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.note == null ? 'إضافة ملاحظة جديدة' : 'تعديل الملاحظة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _saveNote(noteViewModel),
                icon: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                tooltip: 'حفظ الملاحظة',
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, color: borderColor),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Color Palette Selector ──────────────────────────────
                  const SwitchColor(),

                  const SizedBox(height: 20),

                  // ─── Note Title Input ─────────────────────────────────────
                  Text(
                    'العنوان',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب عنوان الملاحظة...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                        fontFamily: 'Cairo',
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Note Content Area ────────────────────────────────────
                  Text(
                    'محتوى الملاحظة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(minHeight: 240),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      minLines: 8,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب ملاحظتك هنا...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                          fontFamily: 'Cairo',
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Full-width Save Button ───────────────────────────────
                  AppButton(
                    label: widget.note == null ? 'حفظ الملاحظة' : 'حفظ التعديلات',
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: () => _saveNote(noteViewModel),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
