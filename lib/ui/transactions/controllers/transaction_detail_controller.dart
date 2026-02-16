import 'dart:async';
import 'package:get/get.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/domain/entities/transaction.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';
import 'package:safuku/utils/logger.dart';

class TransactionDetailController extends GetxController {
  late final TransactionRepository _transactionRepository;
  late final List<StreamSubscription> _subscriptions;

  @override
  void onInit() {
    super.onInit();
    _transactionRepository = Get.find<TransactionRepository>();
    selectedTransactionId.value = Get.parameters['id'];

    if (selectedTransactionId.value?.trim().isNotEmpty ?? false) {
      getTransactionById(int.parse(selectedTransactionId.value!));
    }

    final eventBus = Get.find<AppEventBus>();
    _subscriptions = [
      eventBus.on(AppEvent.transactionChanged, (_) {
        AppLogger.i(
          'TransactionDetailController: transactionChanged event received',
        );
        if (selectedTransactionId.value != null) {
          getTransactionById(int.parse(selectedTransactionId.value!));
        }
      }),
    ];
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  // State
  Rx<TransactionEntity?> transactionData = Rx<TransactionEntity?>(null);
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<String?> selectedTransactionId = Rx<String?>(null);

  Future<void> getTransactionById(int id) async {
    isLoading.value = true;
    try {
      AppLogger.i("Controller : Fetching transaction by id $id");
      final result = await _transactionRepository.getTransactionById(id);
      result.fold(
        (failure) {
          AppLogger.e("Controller : Transaction failed ${failure.message}");
          SnackbarHelper.showError(failure);
        },
        (success) {
          AppLogger.i(
            "Controller : Transaction fetched successfully (description: ${success.description})",
          );
          transactionData.value = success;
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
      SnackbarHelper.showError(
        Failure(title: "Error", message: "Failed to get transaction"),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction() async {
    final id = transactionData.value?.id;
    if (id == null) return;

    try {
      AppLogger.i("Controller : Deleting transaction with id: $id");
      final result = await _transactionRepository.deleteTransaction(id);
      result.fold(
        (failure) {
          AppLogger.e("Controller : Delete failed ${failure.message}");
          SnackbarHelper.showError(failure);
        },
        (_) {
          AppLogger.i("Controller : Transaction deleted successfully");
          final eventBus = Get.find<AppEventBus>();
          eventBus.emit(AppEvent.transactionChanged);
          Get.back();
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
      SnackbarHelper.showError(
        Failure(title: "Error", message: "Failed to delete transaction"),
      );
    }
  }
}
