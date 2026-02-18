import 'package:get/get.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/controllers/personalization_controller.dart';
import 'package:safuku/ui/core/controllers/shell_controller.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/formatter.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/repositories/personalization_repository_impl.dart';

class InitialBinding {
  static Future<void> init() async {
    Get.put<AppEventBus>(AppEventBus(), permanent: true);
    Get.put<DatabaseHelper>(DatabaseHelper.instance, permanent: true);

    // Personalization repository
    final personalizationRepository = await PersonalizationImpl.create();
    Get.put<PersonalizationRepository>(
      personalizationRepository,
      permanent: true,
    );

    Get.put<PersonalizationController>(
      PersonalizationController(
        repository: Get.find<PersonalizationRepository>(),
      ),
    );

    Get.put<ShellController>(ShellController(), permanent: true);

    Get.put<FormatterInterface>(
      Formatter(
        personalizationController: Get.find<PersonalizationController>(),
      ),
    );
  }
}
