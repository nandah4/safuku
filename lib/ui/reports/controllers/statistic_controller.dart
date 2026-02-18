import 'dart:async';
import 'package:get/get.dart';
import 'package:safuku/domain/entities/category_spending.dart';
import 'package:safuku/domain/entities/weekly_summary.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/core/utils/logger.dart';

class StatisticController extends GetxController {
  final TransactionRepository _transactionRepository;
  final AppEventBus _eventBus;
  late final List<StreamSubscription> _subscriptions;

  StatisticController({
    required TransactionRepository transactionRepository,
    required AppEventBus eventBus,
  }) : _transactionRepository = transactionRepository,
       _eventBus = eventBus;

  // State
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final RxString filterType = 'expense'.obs;
  final RxInt selectedSubTab = 0.obs;
  final RxBool isLoading = false.obs;

  // Data
  final Rx<List<CategorySpendingEntity>> categorySpending = Rx([]);
  final Rx<List<WeeklySummaryEntity>> weeklyBreakdown = Rx([]);

  // Computed
  int get totalSpending =>
      categorySpending.value.fold(0, (sum, item) => sum + item.totalAmount);

  int get totalWeeklyAmount =>
      weeklyBreakdown.value.fold(0, (sum, item) => sum + item.totalAmount);

  int get totalWeeklyTransactions =>
      weeklyBreakdown.value.fold(0, (sum, item) => sum + item.transactionCount);

  int get averageWeeklyAmount {
    if (weeklyBreakdown.value.isEmpty) return 0;
    return totalWeeklyAmount ~/ weeklyBreakdown.value.length;
  }

  int get highestWeekNumber {
    if (weeklyBreakdown.value.isEmpty) return 0;
    return weeklyBreakdown.value
        .reduce((a, b) => a.totalAmount > b.totalAmount ? a : b)
        .weekNumber;
  }

  @override
  void onInit() {
    super.onInit();

    _subscriptions = [
      _eventBus.on(AppEvent.transactionChanged, (_) {
        AppLogger.i('StatisticController: transactionChanged event received');
        _refreshData();
      }),
      _eventBus.on(AppEvent.walletChanged, (_) {
        AppLogger.i('StatisticController: walletChanged event received');
        _refreshData();
      }),
    ];

    _refreshData();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    _refreshData();
  }

  void setFilterType(String type) {
    filterType.value = type;
    getSpendingByCategory();
  }

  void setSubTab(int index) {
    selectedSubTab.value = index;
  }

  void _refreshData() {
    getSpendingByCategory();
    getWeeklyBreakdown();
  }

  Future<void> getSpendingByCategory() async {
    isLoading.value = true;
    try {
      final result = await _transactionRepository.getSpendingByCategory(
        selectedDate.value,
        filterType.value,
      );

      result.fold(
        (failure) {
          AppLogger.e(
            "Controller : Spending by category failed ${failure.message}",
          );
        },
        (data) {
          categorySpending.value = data;
          AppLogger.i(
            "Controller : Spending by category fetched (${data.length} categories)",
          );
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWeeklyBreakdown() async {
    try {
      final result = await _transactionRepository.getWeeklyBreakdown(
        selectedDate.value,
      );

      result.fold(
        (failure) {
          AppLogger.e(
            "Controller : Weekly breakdown failed ${failure.message}",
          );
        },
        (data) {
          weeklyBreakdown.value = data;
          AppLogger.i(
            "Controller : Weekly breakdown fetched (${data.length} weeks)",
          );
        },
      );
    } catch (e) {
      AppLogger.e("Controller : Unexpected error ${e.toString()}");
    }
  }
}
