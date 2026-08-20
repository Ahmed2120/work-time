import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_time/core/services/google_drive_service.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/views/components/functions.dart';

class BackupViewModel with ChangeNotifier {
  final GoogleDriveService googleDriveService;

  BackupViewModel({GoogleDriveService? driveService})
      : googleDriveService = driveService ?? GoogleDriveService();

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  CloudBackupMetadata? _backupMetadata;
  CloudBackupMetadata? get backupMetadata => _backupMetadata;

  bool _isCheckingAuth = false;
  bool get isCheckingAuth => _isCheckingAuth;

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  String _signInError = "";
  String get signInError => _signInError;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  bool _isRestoring = false;
  bool get isRestoring => _isRestoring;

  // ─── Weekly Auto Cloud Sync State ──────────────────────────────────────────
  bool _isAutoSyncEnabled = true;
  bool get isAutoSyncEnabled => _isAutoSyncEnabled;

  DateTime? _lastAutoSyncTime;
  DateTime? get lastAutoSyncTime => _lastAutoSyncTime;

  /// Check Google sign-in status and trigger weekly auto-sync check
  Future<void> initGoogleAuth() async {
    _isCheckingAuth = true;
    notifyListeners();

    try {
      // Load auto sync preferences
      final autoSyncVal = CacheHelper.getData(key: 'auto_sync_enabled');
      _isAutoSyncEnabled = autoSyncVal == null ? true : (autoSyncVal as bool);

      final lastSyncStr = CacheHelper.getData(key: 'last_auto_sync_time') as String?;
      if (lastSyncStr != null && lastSyncStr.isNotEmpty) {
        _lastAutoSyncTime = DateTime.tryParse(lastSyncStr);
      }

      _currentUser = await googleDriveService.signInSilently();
      if (_currentUser != null) {
        await refreshBackupMetadata();
        await checkAndPerformWeeklyAutoSync();
      }
    } catch (e) {
      debugPrint("Auth init error: $e");
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  /// Silently perform weekly cloud backup if signed in and >= 7 days passed
  Future<void> checkAndPerformWeeklyAutoSync() async {
    if (!_isAutoSyncEnabled || !isSignedIn) return;

    final now = DateTime.now();
    final shouldSync = _lastAutoSyncTime == null ||
        now.difference(_lastAutoSyncTime!).inDays >= 7;

    if (!shouldSync) return;

    try {
      debugPrint("Starting weekly silent auto cloud backup...");
      await googleDriveService.uploadDatabase();
      _lastAutoSyncTime = now;
      await CacheHelper.saveData(
        key: 'last_auto_sync_time',
        value: now.toIso8601String(),
      );
      await refreshBackupMetadata();
      debugPrint("Weekly silent auto cloud backup completed successfully ✅");
    } catch (e) {
      debugPrint("Weekly silent auto backup failed: $e");
    }
  }

  Future<void> toggleAutoSync(bool value) async {
    _isAutoSyncEnabled = value;
    await CacheHelper.saveData(key: 'auto_sync_enabled', value: value);
    if (value && isSignedIn) {
      await checkAndPerformWeeklyAutoSync();
    }
    notifyListeners();
  }

  Future<void> signInGoogle() async {
    _isSigningIn = true;
    notifyListeners();

    try {
      _currentUser = await googleDriveService.signIn();
      if (_currentUser != null) {
        await refreshBackupMetadata();
        await checkAndPerformWeeklyAutoSync();
      }
      _signInError = "";
    } catch (e) {
      debugPrint("Sign-in error: $e");
      _signInError = e.toString();
      notifyListeners();
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> signOutGoogle() async {
    await googleDriveService.signOut();
    _currentUser = null;
    _backupMetadata = null;
    notifyListeners();
  }

  Future<void> refreshBackupMetadata() async {
    if (!isSignedIn) return;
    try {
      _backupMetadata = await googleDriveService.getCloudBackupInfo();
    } catch (e) {
      debugPrint("Error fetching metadata: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> performBackup(BuildContext context) async {
    if (!isSignedIn) {
      await signInGoogle();
      if (!isSignedIn) {
        if (context.mounted) {
          showToast(context, 'يرجى تسجيل الدخول إلى حساب Google أولاً', color: Colors.amber);
        }
        return;
      }
    }

    _isUploading = true;
    notifyListeners();

    try {
      await googleDriveService.uploadDatabase();
      _lastAutoSyncTime = DateTime.now();
      await CacheHelper.saveData(
        key: 'last_auto_sync_time',
        value: _lastAutoSyncTime!.toIso8601String(),
      );
      await refreshBackupMetadata();
      if (context.mounted) {
        showToast(context, 'تم رفع النسخة الاحتياطية على Google Drive بنجاح ✅');
      }
    } catch (e) {
      debugPrint("Backup upload error: $e");
      if (context.mounted) {
        showToast(context, 'فشل رفع النسخة الاحتياطية: ${e.toString().replaceAll('Exception:', '')}', color: Colors.red);
      }
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> performRestore(BuildContext context, {required VoidCallback onSuccess}) async {
    if (!isSignedIn) {
      await signInGoogle();
      if (!isSignedIn) {
        if (context.mounted) {
          showToast(context, 'يرجى تسجيل الدخول إلى حساب Google أولاً', color: Colors.amber);
        }
        return;
      }
    }

    _isRestoring = true;
    notifyListeners();

    try {
      await googleDriveService.restoreDatabase();
      if (context.mounted) {
        showToast(context, 'تمت استعادة البيانات بنجاح ✅');
      }
      onSuccess();
    } catch (e) {
      debugPrint("Restore error: $e");
      if (context.mounted) {
        showToast(context, 'فشلت استعادة البيانات: ${e.toString().replaceAll('Exception:', '')}', color: Colors.red);
      }
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }
}
