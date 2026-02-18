import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safuku/domain/entities/transaction.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/core/utils/logger.dart';

class TransactionHistoryController extends GetxController {
  final TransactionRepository _transactionRepository;
  final AppEventBus _eventBus;
  late final List<StreamSubscription> _subscriptions;

  TransactionHistoryController({
    required TransactionRepository transactionRepository,
    required AppEventBus eventBus,
  }) : _transactionRepository = transactionRepository,
       _eventBus = eventBus;

  @override
  void onInit() {
    super.onInit();

    _subscriptions = [
      _eventBus.on(AppEvent.transactionChanged, (_) {
        getTransactions();
      }),
      _eventBus.on(AppEvent.walletChanged, (_) {
        getTransactions();
      }),
    ];

    getTransactions();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  // State
  final Rx<List<TransactionEntity>> transactions = Rx<List<TransactionEntity>>(
    [],
  );

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;

    AppLogger.d("Selected Date: ${selectedDate.value}");

    getTransactions();
  }

  // Formatted
  RxString get formattedDate => selectedDate.value != null
      ? DateFormat("MMMM yyyy").format(selectedDate.value!).obs
      : Get.context!.localizations.allTime.obs;

  // Computed State - Grouping transaction by date
  Map<String, List<TransactionEntity>> get groupedTransactions {
    final Map<String, List<TransactionEntity>> grouped = {};

    for (var transaction in transactions.value) {
      final String key = DateFormat("dd MMMM yyyy").format(transaction.date);

      if (grouped[key] == null) {
        grouped[key] = [];
      }
      grouped[key]!.add(transaction);
    }
    return grouped;
  }

  Future<void> getTransactions() async {
    try {
      final result = await _transactionRepository.getAllTransactions(
        null,
        selectedDate.value,
      );

      result.fold(
        (failure) {
          AppLogger.e(failure.message ?? "Error");
        },
        (res) {
          transactions.value = res;
        },
      );
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }
}
