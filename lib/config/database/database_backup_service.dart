import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/core/utils/errors/exception.dart' as exc;
import 'package:safuku/core/utils/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseBackupService {
  final DatabaseHelper databaseHelper;

  DatabaseBackupService({required this.databaseHelper});

  Future<String> databasePath() async {
    final dbPath = await getDatabasesPath();
    return p.join(dbPath, 'safuku.db');
  }

  /// Backup database: close → copy → share → reopen.
  /// Throws [FileSystemException] if file not found.
  /// Throws [exc.ShareDismissedException] if user cancels share.
  Future<void> backupDatabase() async {
    try {
      final dbPath = await databasePath();

      await databaseHelper.close();

      final appDirectory = await getApplicationDocumentsDirectory();
      final backupFileName = DateTime.now().millisecondsSinceEpoch;
      final backupPath = p.join(
        appDirectory.path,
        'safuku_backup_$backupFileName.db',
      );

      final originalFile = File(dbPath);

      if (!await originalFile.exists()) {
        AppLogger.e("SERVICE : Database file not found");
        throw FileSystemException("Database file not found");
      }

      await originalFile.copy(backupPath);

      final params = ShareParams(files: [XFile(backupPath)]);
      final result = await SharePlus.instance.share(params);

      // Clean up temporary backup file
      final tempBackup = File(backupPath);
      if (await tempBackup.exists()) {
        await tempBackup.delete();
      }

      if (result.status == ShareResultStatus.dismissed) {
        throw exc.ShareDismissedException("Backup share was dismissed");
      }

      AppLogger.i("Database backed up successfully");
    } catch (e) {
      rethrow;
    } finally {
      await databaseHelper.database;
    }
  }

  /// Restore database: pick file → validate → close → copy → reopen.
  /// Throws [FileSystemException] if no file selected.
  /// Throws [exc.DatabaseException] if file is not a valid database.
  Future<void> restoreDatabase() async {
    try {
      final file = await FilePicker.platform.pickFiles();

      if (file == null || file.files.first.path == null) {
        AppLogger.e("SERVICE : No file selected");
        // throw FileSystemException("No file selected");
        return;
      }

      final selectedFile = file.files.first.path!;

      // Validate file extension
      if (!selectedFile.endsWith('.db')) {
        throw FileSystemException(
          "Invalid file format. Please select a .db file",
        );
      }

      final dbLocation = await databasePath();

      await databaseHelper.close();

      final File backupFile = File(selectedFile);
      await backupFile.copy(dbLocation);

      // Reopen and verify integrity
      final db = await databaseHelper.database;
      final integrityCheck = await db.rawQuery('PRAGMA integrity_check');
      final checkResult = integrityCheck.first.values.first as String;

      if (checkResult != 'ok') {
        AppLogger.e("Database integrity check failed: $checkResult");
        throw exc.DatabaseException("Restored database is corrupted");
      }

      AppLogger.i("Database restored successfully from: $selectedFile");
    } catch (e) {
      rethrow;
    } finally {
      await databaseHelper.database;
    }
  }

  Future<void> clearDatabase() async {
    try {
      final database = await databaseHelper.database;

      // Delete data from every table
      await database.transaction((txn) async {
        await txn.rawDelete('DELETE FROM trx_transaction');
        await txn.rawDelete('DELETE FROM mst_wallet');
        await txn.rawDelete('DELETE FROM mst_category');
      });

      AppLogger.i("Database cleared successfully");
    } catch (e) {
      AppLogger.e("SERVICE : Failed to clear database: $e");
      rethrow;
    }
  }
}
