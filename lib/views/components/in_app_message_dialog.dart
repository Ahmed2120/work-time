import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_time/core/services/in_app_message_service.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/in_app_alert.dart';

/// Decoupled, modular Dialog for presenting In-App Alerts sent remotely from Firebase.
/// Complies with SOLID and UI separation rules.
class InAppMessageDialog extends StatelessWidget {
  final InAppAlert alert;

  const InAppMessageDialog({required this.alert, super.key});

  /// Displays the alert dialog smoothly and triggers Phase 1 acknowledgment upon dismissal.
  static Future<void> show(BuildContext context, InAppAlert alert) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => InAppMessageDialog(alert: alert),
    );
    // Mark as read (Phase 1 local ack & immediate sync attempt)
    await InAppMessageService.markAlertAsRead(alert);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertConfig = _getTypeConfig(alert.type);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header Icon with Ambient Halo ─────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alertConfig.color.withValues(alpha: isDark ? 0.22 : 0.12),
              ),
              child: Center(
                child: Icon(
                  alertConfig.icon,
                  size: 32,
                  color: alertConfig.color,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ─── Alert Title ──────────────────────────────────────────────
            Text(
              alert.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 12),

            // ─── Alert Message Body ────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  alert.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ─── Action Button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: alertConfig.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();

                  // If an external URL is attached, launch it safely
                  if (alert.actionUrl != null && alert.actionUrl!.isNotEmpty) {
                    final uri = Uri.tryParse(alert.actionUrl!);
                    if (uri != null) {
                      try {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } catch (_) {
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      }
                    }
                  }
                },
                child: Text(
                  alert.actionText ?? context.l10n.dialogOk,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _AlertTypeConfig _getTypeConfig(String type) {
    switch (type) {
      case 'feature':
        return _AlertTypeConfig(
          icon: Icons.lightbulb_rounded,
          color: AppColors.primaryAmber,
        );
      case 'success':
        return _AlertTypeConfig(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        );
      case 'warning':
        return _AlertTypeConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        );
      case 'info':
      default:
        return _AlertTypeConfig(
          icon: Icons.mark_chat_unread_rounded,
          color: AppColors.primaryPurple,
        );
    }
  }
}

class _AlertTypeConfig {
  final IconData icon;
  final Color color;

  const _AlertTypeConfig({required this.icon, required this.color});
}
