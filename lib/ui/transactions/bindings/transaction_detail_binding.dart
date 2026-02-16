import 'package:get/get.dart';
import 'package:safuku/ui/transactions/controllers/transaction_detail_controller.dart';

class TransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionDetailController());
  }
}
