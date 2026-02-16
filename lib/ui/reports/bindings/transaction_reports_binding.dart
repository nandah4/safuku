import 'package:get/get.dart';
import 'package:safuku/ui/reports/controllers/transaction_history_controller.dart';

class TransactionReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryController>(
      () => TransactionHistoryController(),
    );
  }
}
