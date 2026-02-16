import 'package:get/get.dart';
import 'package:safuku/data/datasource/local/transaction_local.dart';
import 'package:safuku/data/datasource/local/wallet_local.dart';
import 'package:safuku/data/repositories/transaction_repository_impl.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import '../../../config/database/database_helper.dart';
import '../../../data/datasource/local/category_local.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../../ui/transactions/controllers/category_controller.dart';
import '../../../ui/transactions/controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    // Transaction dependencies
    Get.lazyPut<TransactionLocalDataSource>(
      () => TransactionLocalDataSource(db: Get.find<DatabaseHelper>()),
    );
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepositoryImpl(
        databaseHelper: Get.find<DatabaseHelper>(),
        walletLocalDataSource: Get.find<WalletDataSource>(),
        transactionLocalDataSource: Get.find<TransactionLocalDataSource>(),
      ),
    );
    Get.lazyPut<TransactionController>(() => TransactionController());

    // Category dependencies
    Get.lazyPut<CategoryLocalDataSource>(
      () => CategoryLocalDataSource(databaseHelper: Get.find<DatabaseHelper>()),
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(
        categoryLocalDataSource: Get.find<CategoryLocalDataSource>(),
      ),
    );
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
