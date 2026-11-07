import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';

/// مساحة توجيهية هادئة وغير مهيمنة بصرياً لحث المستخدم على تسجيل وإضافة العمال
class ProjectEmptyWorkersHint extends StatelessWidget {
  final bool isZeroWorkers;

  const ProjectEmptyWorkersHint({
    super.key,
    this.isZeroWorkers = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                IconlyLight.addUser,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isZeroWorkers) ...[
            Text(
              context.l10n.noWorkersOnSiteYet,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            context.l10n.addWorkersHint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
