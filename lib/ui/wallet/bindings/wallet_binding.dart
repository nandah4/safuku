import 'package:get/instance_manager.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/datasource/local/wallet_local.dart';
import 'package:safuku/data/repositories/wallet_repository_impl.dart';
import 'package:safuku/domain/repositories/wallet_repository.dart';
import 'package:safuku/ui/wallet/controllers/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    // Wallet datasource
    Get.lazyPut<WalletDataSource>(
      () => WalletDataSource(db: Get.find<DatabaseHelper>()),
    );

    // Wallet repository
    Get.lazyPut<WalletRepository>(
      () =>
          WalletRepositoryImpl(walletDataSource: Get.find<WalletDataSource>()),
    );

    // Wallet Controller
    Get.put<WalletController>(
      WalletController(walletRepository: Get.find<WalletRepository>()),
    );
  }
}
