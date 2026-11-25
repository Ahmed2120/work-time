import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/penalty.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/penalty_view_model.dart';
import 'package:work_time/views/components/app_card.dart';
import 'package:work_time/views/components/functions.dart';

import 'add_penalty_bottom_sheet.dart';

class PenaltiesListCard extends StatefulWidget {
  final User user;

  const PenaltiesListCard({required this.user, super.key});

  @override
  State<PenaltiesListCard> createState() => _PenaltiesListCardState();
}

class _PenaltiesListCardState extends State<PenaltiesListCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.user.id != null) {
        Provider.of<PenaltyViewModel>(context, listen: false)
            .getPenaltiesForUser(widget.user.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final penaltyVM = Provider.of<PenaltyViewModel>(context);
    final penalties = penaltyVM.penalties;
    final totalPenalties = penaltyVM.getTotalPenalties();
    final currency = context.currency;

    final hasMultiple = penalties.length > 1;

    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.penalties,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              // Add Penalty Button
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(
                  context.l10n.addPenalty,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                onPressed: () => AddPenaltyBottomSheet.show(context, user: widget.user),
              ),
            ],
          ),

          if (penalties.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.totalPenalties,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    '${_formatNum(totalPenalties)} $currency',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 8),

          if (penalties.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  context.l10n.noPenalties,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            )
          else if (!hasMultiple)
            // Single penalty: no need for expand/collapse
            _buildPenaltyRow(penalties.first, isDark, currency, penaltyVM)
          else
            // Multiple penalties: expandable with gradient opacity mask
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 280),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildCollapsedView(penalties, isDark, currency, penaltyVM),
              secondChild: _buildExpandedView(penalties, isDark, currency, penaltyVM),
            ),
        ],
      ),
    );
  }

  /// Collapsed view: shows 1st item and 2nd item fading out with a vertical gradient mask + expand footer.
  Widget _buildCollapsedView(
    List<Penalty> penalties,
    bool isDark,
    String currency,
    PenaltyViewModel penaltyVM,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isExpanded = true),
      child: Column(
        children: [
          // Gradient Fade-Out Opacity Mask without overflow
          ClipRect(
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.40, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: SizedBox(
                height: 72,
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: penalties
                          .take(2)
                          .map((p) => _buildPenaltyRow(p, isDark, currency, penaltyVM))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Tap to expand bar with Arrow Down & Count
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${context.l10n.showAllPenalties} (${penalties.length})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expanded view: shows all items + tap to collapse on arrow or card area.
  Widget _buildExpandedView(
    List<Penalty> penalties,
    bool isDark,
    String currency,
    PenaltyViewModel penaltyVM,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isExpanded = false),
      child: Column(
        children: [
          ...penalties.map((p) => _buildPenaltyRow(p, isDark, currency, penaltyVM)),
          const SizedBox(height: 6),

          // Tap to collapse bar with Arrow Up
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.showLess,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyRow(
    Penalty penalty,
    bool isDark,
    String currency,
    PenaltyViewModel penaltyVM,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penalty.reason.isNotEmpty
                      ? penalty.reason
                      : (context.isArabic ? 'جزاء بدون سبب' : 'Penalty'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  penalty.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${_formatNum(penalty.amount)} $currency',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
              fontFamily: 'Cairo',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
            visualDensity: VisualDensity.compact,
            tooltip: context.l10n.deleteWorker,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    context.l10n.confirmDeletePenalty,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Cairo'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(context.isArabic ? 'إلغاء' : 'Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        context.isArabic ? 'حذف' : 'Delete',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && penalty.id != null) {
                await penaltyVM.deletePenalty(penalty.id!, widget.user.id!);
                if (context.mounted) {
                  showToast(context, context.l10n.penaltyDeletedSuccess);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  static String _formatNum(num val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }
}
