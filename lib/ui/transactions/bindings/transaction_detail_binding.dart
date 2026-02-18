import 'package:get/get.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/transactions/controllers/transaction_detail_controller.dart';

class TransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(
        transactionRepository: Get.find<TransactionRepository>(),
        eventBus: Get.find<AppEventBus>(),
      ),
    );
  }
}
