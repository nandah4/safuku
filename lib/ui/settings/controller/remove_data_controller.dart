import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:safuku/config/database/database_backup_service.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/controllers/shell_controller.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';

class RemoveDataController extends GetxController {
  final PersonalizationRepository _personalizationRepository;
  final DatabaseBackupService _databaseBackupService;
  final ShellController _shellController;

  RemoveDataController({
    required PersonalizationRepository personalizationRepository,
    required DatabaseBackupService databaseBackupService,
    required ShellController shellController,
  }) : _personalizationRepository = personalizationRepository,
       _databaseBackupService = databaseBackupService,
       _shellController = shellController;

  Future<void> removeData() async {
    try {
      await _personalizationRepository.clear();
      await _databaseBackupService.clearDatabase();

      // Reset indexed to home
      _shellController.changeIndex(0);

      // Update locale to en and navigate to root (onboard if first time)
      Get.updateLocale(Locale('en'));
      Get.back();
      Get.offAllNamed('/');
    } catch (e) {
      SnackbarHelper.showError(
        DatabaseFailure(message: "Failed to remove data", title: "Error"),
      );
    }
  }
}
