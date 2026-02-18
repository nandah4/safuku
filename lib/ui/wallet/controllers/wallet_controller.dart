import 'dart:async';
import 'package:get/get.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';
import 'package:safuku/core/utils/logger.dart';

import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/domain/repositories/wallet_repository.dart';

class WalletController extends GetxController {
  final WalletRepository walletRepository;
  final AppEventBus _eventBus;

  WalletController({
    required this.walletRepository,
    required AppEventBus eventBus,
  }) : _eventBus = eventBus;

  final List<WalletEntity> wallets = <WalletEntity>[].obs;
  final Rx<int> totalSaldo = 0.obs;

  late final List<StreamSubscription> _subscriptions;

  @override
  void onInit() {
    super.onInit();

    _subscriptions = [
      _eventBus.on(AppEvent.walletChanged, (_) {
        AppLogger.i('WalletController: walletChanged event received');
        getAllWallets();
        getTotalSaldo();
      }),
      _eventBus.on(AppEvent.transactionChanged, (_) {
        AppLogger.i('WalletController: transactionChanged event received');
        getTotalSaldo();
        getAllWallets();
      }),
    ];

    getAllWallets();
    getTotalSaldo();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  Future<void> getAllWallets() async {
    final result = await walletRepository.getAllWallets();

    result.fold(
      (failure) {
        AppLogger.e(" Controller : ${failure.message}");
      },
      (data) {
        wallets.assignAll(data);
        AppLogger.i(" Controller : Wallet load successfully");
      },
    );
  }

  Future<void> deleteWallet(int? id) async {
    if (id == null) {
      AppLogger.e(" Controller : Wallet ID is null");
      return;
    }

    final result = await walletRepository.deleteWallet(id);

    result.fold(
      (failure) {
        AppLogger.e(" Controller : ${failure.message}");
        SnackbarHelper.showError(failure);
      },
      (success) async {
        AppLogger.i(" Controller : Wallet deleted successfully");
        await getAllWallets();
        await getTotalSaldo();
      },
    );
  }

  Future<void> getTotalSaldo() async {
    final result = await walletRepository.getTotalSaldo();

    result.fold(
      (failure) {
        AppLogger.e(" Controller : ${failure.message}");
      },
      (data) {
        totalSaldo.value = data;
        AppLogger.i(" Controller : Total Saldo load successfully");
      },
    );
  }
}
