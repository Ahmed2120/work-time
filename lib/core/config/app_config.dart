/// Global App Configuration & Feature Flags for Build Variants.
class AppConfig {
  /// Toggle this flag before building a release version:
  /// - `true`: Enables WhatsApp-style Google Drive Cloud Backup & Restore.
  /// - `false`: Hides and disables all cloud backup functionality for this build.
  static const bool enableBackupFeature = true;
}
