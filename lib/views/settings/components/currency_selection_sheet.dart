import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/currency_item.dart';
import 'package:work_time/view_models/currency_view_model.dart';
import 'package:work_time/views/components/functions.dart';

class CurrencySelectionSheet extends StatefulWidget {
  const CurrencySelectionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CurrencySelectionSheet(),
    );
  }

  @override
  State<CurrencySelectionSheet> createState() => _CurrencySelectionSheetState();
}

class _CurrencySelectionSheetState extends State<CurrencySelectionSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyVM = Provider.of<CurrencyViewModel>(context);
    final isAr = context.isArabic;

    final filteredList = currencyVM.allCurrencies.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c.code.toLowerCase().contains(q) ||
          c.nameAr.toLowerCase().contains(q) ||
          c.nameEn.toLowerCase().contains(q) ||
          c.symbolAr.toLowerCase().contains(q) ||
          c.symbolEn.toLowerCase().contains(q);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 14, left: 16, right: 16),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? 'اختر العملة' : 'Select Currency',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: isAr ? 'بحث عن عملة أو دولة...' : 'Search currency or country...',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontFamily: 'Cairo',
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
          ),
          const SizedBox(height: 12),

          // Currencies List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredList.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              itemBuilder: (ctx, idx) {
                final item = filteredList[idx];
                final isSelected = item.code == currencyVM.code;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    await currencyVM.setCurrency(item);
                    if (context.mounted) {
                      Navigator.pop(context);
                      showToast(
                        context,
                        isAr
                            ? 'تم ضبط العملة إلى ${item.nameAr} (${item.symbolAr})'
                            : 'Currency set to ${item.nameEn} (${item.symbolEn})',
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        // Flag
                        Text(
                          item.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 14),

                        // Name & Code
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.getName(isAr),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                '${item.code} • ${item.getSymbol(isAr)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Symbol badge & checkmark
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppColors.primary.withValues(alpha: 0.25) : AppColors.primaryLight)
                                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.getSymbol(isAr),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
