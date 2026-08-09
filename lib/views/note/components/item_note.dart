import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/app_card.dart';

import '../../../core/utils/global_methods.dart';
import '../../../data/models/note.dart';
import '../../../view_models/note_view_model.dart';
import '../../components/constant.dart';
import 'note_editor.dart';

class ItemNote extends StatelessWidget {
  const ItemNote({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () {
        push(screen: NoteEditor(note: note), context: context);
      },
      child: Row(
        children: [
          // Subtle Indigo Accent Vertical Strip
          Container(
            width: 3,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Note Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${GlobalMethods.getDayName(DateTime.parse(note.dateCreated))}، '
                  '${GlobalMethods.getDateFormat(DateTime.parse(note.dateCreated))}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),

          // Clean Delete Action
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.dangerText,
              size: 20,
            ),
            onPressed: () {
              Provider.of<NoteViewModel>(context, listen: false).deleteNote(note);
            },
          ),
        ],
      ),
    );
  }
}
