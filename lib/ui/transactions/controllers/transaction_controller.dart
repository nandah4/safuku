import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safuku/domain/entities/transaction.dart';
import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/domain/repositories/wallet_repository.dart';
import 'package:safuku/ui/core/utils/amount_validator.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/ui/core/utils/formatter.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';
import 'package:safuku/utils/logger.dart';

class TransactionController extends GetxController {
  late final WalletRepository _walletRepository;
  late final TransactionRepository _transactionRepository;

  // State action flag
  RxBool isUpdating = false.obs;

  // Transaction data
  Rx<TransactionEntity?> transactionData = Rx<TransactionEntity?>(null);

  // Form State and Controller
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController amountController;
  late TextEditingController nameController;
  late TextEditingController notesController;

  // State and Error State
  RxString transactionType = "".obs;
  RxString walletId = "".obs;
  RxString categoryId = "".obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());
  Rx<bool> isLoading = Rx<bool>(false);

  Rx<String> amountError = Rx<String>("");
  Rx<String> walletError = Rx<String>("");
  Rx<String> transactionTypeError = Rx<String>("");
  Rx<String> categoryError = Rx<String>("");
  Rx<String> notesError = Rx<String>("");
  final Rx<List<WalletEntity>> wallets = Rx([]);

  // Getter
  String get formattedDate =>
      DateFormat("dd MMMM yyyy").format(selectedDate.value ?? DateTime.now());

  late final List<StreamSubscription> _subscriptions;

  @override
  void onInit() {
    super.onInit();
    _walletRepository = Get.find<WalletRepository>();
    _transactionRepository = Get.find<TransactionRepository>();
    amountController = TextEditingController();
    nameController = TextEditingController();
    notesController = TextEditingController();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args?['transaction'] != null) {
      isUpdating.value = true;
      transactionData.value = args!['transaction'] as TransactionEntity;

      amountController.text = Get.find<Formatter>().formatAmountWithoutCurrency(
        transactionData.value!.amount,
      );
      nameController.text = transactionData.value!.title;
      notesController.text = transactionData.value!.description ?? "";
      selectedDate.value = transactionData.value!.date;
      transactionType.value = transactionData.value!.type;
      walletId.value = transactionData.value!.walletId.toString();
      categoryId.value = transactionData.value!.categoryId.toString();
    }

    final eventBus = Get.find<AppEventBus>();
    _subscriptions = [
      eventBus.on(AppEvent.walletChanged, (_) {
        AppLogger.i('TransactionController: walletChanged event received');
        getWallets();
      }),
    ];

    getWallets();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    amountController.dispose();
    nameController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void setSelectedCategoryId(String id) {
    categoryId.value = id;
  }

  Future<void> getWallets() async {
    try {
      final walletsResult = await _walletRepository.getAllWallets();
      walletsResult.fold(
        (failure) {
          SnackbarHelper.showError(
            Failure(title: "Error", message: "Failed to get wallets"),
          );
          AppLogger.e(failure.message ?? failure.toString());
        },
        (data) {
          wallets(data);
        },
      );
    } catch (e) {
      SnackbarHelper.showError(
        Failure(title: "Error", message: "Failed to get wallets"),
      );
      AppLogger.e(e.toString());
    }
  }

  /// Validates all form fields. Returns true if all valid.
  bool _validateForm() {
    bool isValid = true;

    if (transactionType.value.isEmpty) {
      transactionTypeError.value = "Transaction type is required";
      isValid = false;
    }

    if (walletId.value.isEmpty) {
      walletError.value = "Wallet is required";
      isValid = false;
    }

    if (categoryId.value.isEmpty) {
      categoryError.value = "Category is required";
      isValid = false;
    }

    return isValid;
  }

  /// Resets all form fields and error states.
  void _resetForm() {
    amountController.clear();
    nameController.clear();
    notesController.clear();
    transactionType.value = "";
    walletId.value = "";
    categoryId.value = "";
    selectedDate.value = DateTime.now();
    amountError.value = "";
    walletError.value = "";
    transactionTypeError.value = "";
    categoryError.value = "";
    notesError.value = "";
  }

  Future<void> submitTransaction() async {
    if (!_validateForm()) return;
    final amountResult = AmountValidator.validateAmount(amountController.text);
    if (amountResult != null) {
      amountError.value = amountResult;
      AppLogger.e("CONTROLLER (FAILED VALIDATE AMOUNT) : ${amountError.value}");
      return;
    }

    final amount = AmountValidator.parseAmount(amountController.text);
    if (amount == null) {
      AppLogger.e("CONTROLLER (FAILED PARSE AMOUNT) : $amount");
      amountError.value = "Invalid amount";
      return;
    }

    isLoading.value = true;
    try {
      final transactionEntity = TransactionEntity(
        id: isUpdating.value ? transactionData.value!.id : null,
        walletId: int.parse(walletId.value),
        categoryId: int.parse(categoryId.value),
        amount: amount,
        type: transactionType.value,
        title: nameController.text.trim(),
        description: notesController.text.trim(),
        date: selectedDate.value ?? DateTime.now(),
      );

      dynamic result;

      if (transactionData.value == null && isUpdating.value) {
        SnackbarHelper.showError(
          Failure(title: "Error", message: "Transaction data is empty"),
        );
        AppLogger.e("Controller : Transaction data is null");
        return;
      }

      if (isUpdating.value) {
        result = await _transactionRepository.updateTransaction(
          transactionEntity,
          transactionData.value!,
        );
        AppLogger.i("Controller : Transaction updated successfully");
      } else {
        result = await _transactionRepository.createTransaction(
          transactionEntity,
        );
        AppLogger.i("Controller : Transaction created successfully");
      }

      result.fold(
        (failure) {
          AppLogger.e("Controller : Transaction failed ${failure.message}");
          SnackbarHelper.showError(failure);
        },
        (success) {
          AppLogger.i(
            "Controller : Transaction created successfully (id: $success)",
          );
          final eventBus = Get.find<AppEventBus>();
          eventBus.emit(AppEvent.transactionChanged);
          eventBus.emit(AppEvent.walletChanged);
          _resetForm();
          Get.back();
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
      SnackbarHelper.showError(
        Failure(title: "Error", message: "Failed to create transaction"),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
