import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safuku/domain/entities/transaction.dart';
import 'package:safuku/domain/entities/transaction_type.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/core/utils/logger.dart';

class HomeController extends GetxController {
  final TransactionRepository _transactionRepository;
  final AppEventBus _eventBus;
  final ScrollController scrollController = ScrollController();
  late final List<StreamSubscription> _subscriptions;

  HomeController({
    required TransactionRepository transactionRepository,
    required AppEventBus eventBus,
  }) : _transactionRepository = transactionRepository,
       _eventBus = eventBus;

  final Rx<TransactionTypeEntity> transactionTypePerMonth = Rx(
    TransactionTypeEntity(date: DateTime.now(), income: 0, expense: 0),
  );

  // State
  RxBool isBalanceVisible = true.obs;
  RxBool isScrolled = false.obs;
  final Rx<DateTime> selectedDate = Rx(DateTime.now());

  void setSelectedDate(DateTime date) {
    selectedDate(date);
    getTransactionTypePerMonth();
  }

  void setBalanceVisible(bool visible) {
    isBalanceVisible(visible);
  }

  @override
  void onInit() {
    super.onInit();

    // Scroll listener
    scrollController.addListener(() {
      if (scrollController.offset > 20) {
        isScrolled(true);
      } else {
        isScrolled(false);
      }
    });

    // Listen to event bus
    _subscriptions = [
      _eventBus.on(AppEvent.transactionChanged, (_) {
        AppLogger.i("Controller : Transaction changed event received");
        getRecentTransaction();
        getTransactionTypePerMonth();
      }),
      _eventBus.on(AppEvent.walletChanged, (_) {
        AppLogger.i("Controller : Wallet changed event received");
        getRecentTransaction();
        getTransactionTypePerMonth();
      }),
    ];

    getRecentTransaction();
    getTransactionTypePerMonth();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    scrollController.dispose();
    super.onClose();
  }

  final Rx<List<TransactionEntity>> recentTransaction = Rx([]);

  Future<void> getRecentTransaction() async {
    try {
      final result = await _transactionRepository.getAllTransactions(5, null);
      result.fold(
        (failure) {
          AppLogger.e("Controller : Transaction failed ${failure.message}");
        },
        (res) {
          AppLogger.i("Controller : Transaction fetched successfully");
          recentTransaction(res);
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
    }
  }

  Future<void> getTransactionTypePerMonth() async {
    try {
      final result = await _transactionRepository.getTransactionTypePerMonth(
        selectedDate.value,
      );
      result.fold(
        (failure) {
          AppLogger.e(
            "Controller : Transaction type failed ${failure.message}",
          );
        },
        (res) {
          AppLogger.i("Controller : Transaction type fetched successfully");
          transactionTypePerMonth(res);
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
    }
  }
}
