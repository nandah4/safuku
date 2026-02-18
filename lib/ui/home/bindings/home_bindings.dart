import 'package:get/get.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        transactionRepository: Get.find<TransactionRepository>(),
        eventBus: Get.find<AppEventBus>(),
      ),
    );
  }
}
