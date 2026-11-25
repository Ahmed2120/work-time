import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/penalty.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/penalty_view_model.dart';
import 'package:work_time/views/components/app_button.dart';
import 'package:work_time/views/components/custom_textField.dart';
import 'package:work_time/views/components/functions.dart';
import 'package:work_time/views/home/components/bottom_sheet/components/header_sheet.dart';

class AddPenaltyBottomSheet extends StatefulWidget {
  final User user;

  const AddPenaltyBottomSheet({required this.user, super.key});

  static void show(BuildContext context, {required User user}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddPenaltyBottomSheet(user: user),
    );
  }

  @override
  State<AddPenaltyBottomSheet> createState() => _AddPenaltyBottomSheetState();
}

class _AddPenaltyBottomSheetState extends State<AddPenaltyBottomSheet> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dateFormatted =
        '${_selectedDate.year}-${_selectedDate.month < 10 ? '0${_selectedDate.month}' : '${_selectedDate.month}'}-${_selectedDate.day < 10 ? '0${_selectedDate.day}' : '${_selectedDate.day}'}';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderSheet(title: context.l10n.addPenalty),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _amountController,
                    label: '${context.l10n.penaltyAmount} (${context.currency})',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _reasonController,
                    label: context.l10n.penaltyReason,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 14),
                  // Date picker selector row
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                context.isArabic ? 'تاريخ الجزاء:' : 'Date:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            dateFormatted,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  AppButton(
                    label: context.l10n.addPenalty,
                    icon: Icons.gavel_rounded,
                    style: AppButtonStyle.primary,
                    onPressed: () async {
                      final text = _amountController.text.trim();
                      final amount = double.tryParse(text);
                      if (amount == null || amount <= 0) {
                        showToast(context, context.l10n.invalidAmount, color: AppColors.error);
                        return;
                      }

                      final penalty = Penalty(
                        userId: widget.user.id!,
                        amount: amount,
                        reason: _reasonController.text.trim(),
                        date: dateFormatted,
                      );

                      final penaltyVM = Provider.of<PenaltyViewModel>(context, listen: false);
                      await penaltyVM.addPenalty(penalty);

                      if (context.mounted) {
                        showToast(context, context.l10n.penaltyAddedSuccess);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
