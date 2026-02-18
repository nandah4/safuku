import 'dart:io';
import 'package:get/get.dart';
import 'package:safuku/config/database/database_backup_service.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/core/utils/logger.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';
import 'package:safuku/core/utils/errors/exception.dart' as exc;

class BackupController extends GetxController {
  final DatabaseBackupService databaseBackupService;
  final AppEventBus _eventBus;

  BackupController({
    required this.databaseBackupService,
    required AppEventBus eventBus,
  }) : _eventBus = eventBus;

  // State
  final RxBool isLoading = false.obs;

  Future<void> backupDatabase() async {
    try {
      isLoading.value = true;
      await databaseBackupService.backupDatabase();
      AppLogger.i("Database backed up successfully");
    } on FileSystemException catch (e) {
      AppLogger.e("Backup file error: ${e.message}");
      SnackbarHelper.showError(FileSystemFailure(message: e.message));
    } on exc.ShareDismissedException catch (e) {
      AppLogger.e("Backup share dismissed: $e");
      // SnackbarHelper.showError(ShareDismissedException(message: e.toString()));
    } catch (e) {
      AppLogger.e("Backup unknown error: $e");
      SnackbarHelper.showError(UnknownFailure());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restoreDatabase() async {
    try {
      isLoading.value = true;
      await databaseBackupService.restoreDatabase();

      // Notify other controllers to refresh data
      final appBus = _eventBus;
      appBus.emit(AppEvent.transactionChanged);
      appBus.emit(AppEvent.categoryChanged);

      AppLogger.i("Database restored successfully");
    } on FileSystemException catch (e) {
      AppLogger.e("Restore file error: ${e.message}");
      SnackbarHelper.showError(FileSystemFailure(message: e.message));
    } on exc.DatabaseException catch (e) {
      AppLogger.e("Restore database error: $e");
      SnackbarHelper.showError(DatabaseFailure(message: e.toString()));
    } catch (e) {
      AppLogger.e("Restore unknown error: $e");
      SnackbarHelper.showError(UnknownFailure());
    } finally {
      isLoading.value = false;
    }
  }
}
