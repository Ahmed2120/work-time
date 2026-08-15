import 'dart:io';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_time/data/repositories/database_handler.dart';

class CloudBackupMetadata {
  final DateTime modifiedTime;
  final int sizeBytes;

  CloudBackupMetadata({
    required this.modifiedTime,
    required this.sizeBytes,
  });
}

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      debugPrint("Error signing in to Google: $e");
      rethrow;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint("Error in Google silent sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return null;
    return drive.DriveApi(client);
  }

  /// Get backup file metadata stored in Google Drive appDataFolder
  Future<CloudBackupMetadata?> getCloudBackupInfo() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'dgi.db' and trashed = false",
      $fields: 'files(id, name, modifiedTime, size)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      return null;
    }

    final file = fileList.files!.first;
    final modifiedTime = file.modifiedTime ?? DateTime.now();
    final size = int.tryParse(file.size ?? '0') ?? 0;

    return CloudBackupMetadata(
      modifiedTime: modifiedTime,
      sizeBytes: size,
    );
  }

  /// Upload local SQLite dgi.db to Google Drive appDataFolder
  Future<bool> uploadDatabase() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('لم يتم تسجيل الدخول في حساب Google');
    }

    final dbPath = join(await getDatabasesPath(), 'dgi.db');
    final dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      throw Exception('ملف قواعد البيانات المحلي غير موجود');
    }

    final fileSize = await dbFile.length();
    final media = drive.Media(dbFile.openRead(), fileSize);

    // Search if file already exists in appDataFolder
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'dgi.db' and trashed = false",
      $fields: 'files(id)',
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      final existingFileId = fileList.files!.first.id!;
      final updatedFile = drive.File()..modifiedTime = DateTime.now().toUtc();
      await driveApi.files.update(
        updatedFile,
        existingFileId,
        uploadMedia: media,
      );
    } else {
      final fileMetadata = drive.File()
        ..name = 'dgi.db'
        ..parents = ['appDataFolder'];
      await driveApi.files.create(
        fileMetadata,
        uploadMedia: media,
      );
    }

    return true;
  }

  /// Download dgi.db from Google Drive appDataFolder and replace local database
  Future<bool> restoreDatabase() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('لم يتم تسجيل الدخول في حساب Google');
    }

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'dgi.db' and trashed = false",
      $fields: 'files(id, size)',
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('لا توجد نسخة احتياطية على Google Drive لـ هذا الحساب');
    }

    final fileId = fileList.files!.first.id!;
    final drive.Media downloadedMedia = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // Close active SQLite DB connection to allow file overwrite
    await DatabaseHandler().closeDatabase();

    final dbPath = join(await getDatabasesPath(), 'dgi.db');
    final dbFile = File(dbPath);

    // Write downloaded stream to a temp file first, then overwrite
    final tempPath = '$dbPath.tmp';
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    final sink = tempFile.openWrite();
    await downloadedMedia.stream.pipe(sink);

    // Overwrite actual DB file
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    await tempFile.copy(dbPath);
    await tempFile.delete();

    // Re-initialize DatabaseHandler
    await DatabaseHandler().initializeDB();

    return true;
  }
}
