import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_time/core/services/google_drive_service.dart';
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

  /// Check Google sign-in status on app launch or backup screen load
  Future<void> initGoogleAuth() async {
    _isCheckingAuth = true;
    notifyListeners();

    try {
      _currentUser = await googleDriveService.signInSilently();
      if (_currentUser != null) {
        await refreshBackupMetadata();
      }
    } catch (e) {
      debugPrint("Auth init error: $e");
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<void> signInGoogle() async {
    _isSigningIn = true;
    notifyListeners();

    try {
      _currentUser = await googleDriveService.signIn();
      if (_currentUser != null) {
        await refreshBackupMetadata();
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
