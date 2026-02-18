import 'package:get/get.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/reports/controllers/transaction_history_controller.dart';
import 'package:safuku/ui/reports/controllers/statistic_controller.dart';

class TransactionReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryController>(
      () => TransactionHistoryController(
        transactionRepository: Get.find<TransactionRepository>(),
        eventBus: Get.find<AppEventBus>(),
      ),
    );
    Get.lazyPut<StatisticController>(
      () => StatisticController(
        transactionRepository: Get.find<TransactionRepository>(),
        eventBus: Get.find<AppEventBus>(),
      ),
    );
  }
}
