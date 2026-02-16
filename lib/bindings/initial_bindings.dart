import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/repositories/personalization_repository_impl.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/utils/formatter.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/onboard/controllers/language_controller.dart';

class InitialBinding {
  static Future<void> init() async {
    // Event bus (app-level singleton)
    Get.put<AppEventBus>(AppEventBus(), permanent: true);

    // Database helper
    Get.put<DatabaseHelper>(DatabaseHelper.instance, permanent: true);

    // Personalization repository
    final personalizationRepository = await PersonalizationImpl.create();
    Get.put<PersonalizationRepository>(
      personalizationRepository,
      permanent: true,
    );

    Get.put<LanguageController>(LanguageController());

    Get.put<Formatter>(
      Formatter(personalizationRepository: personalizationRepository),
    );
  }
}
