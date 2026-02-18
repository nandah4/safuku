import 'package:get/get.dart';
import 'package:safuku/config/database/database_backup_service.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/controllers/shell_controller.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/settings/controller/backup_controller.dart';
import 'package:safuku/ui/settings/controller/remove_data_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseBackupService>(
      () => DatabaseBackupService(databaseHelper: Get.find<DatabaseHelper>()),
    );
    Get.lazyPut<BackupController>(
      () => BackupController(
        databaseBackupService: Get.find<DatabaseBackupService>(),
        eventBus: Get.find<AppEventBus>(),
      ),
    );
    Get.lazyPut<RemoveDataController>(
      () => RemoveDataController(
        personalizationRepository: Get.find<PersonalizationRepository>(),
        databaseBackupService: Get.find<DatabaseBackupService>(),
        shellController: Get.find<ShellController>(),
      ),
    );
  }
}
