import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/transaction_card_widget.dart';
import 'package:safuku/ui/reports/controllers/transaction_history_controller.dart';

class HistoryTab extends StatelessWidget {
  HistoryTab({super.key});

  final TransactionHistoryController _controller =
      Get.find<TransactionHistoryController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(
          dialogBackgroundColor: context.colorScheme.surface,
          insetPadding: EdgeInsets.all(PaddingScale.lg),
        ),
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: AppColors.primary,
          nextIcon: FontAwesomeIcons.arrowRight,
          previousIcon: FontAwesomeIcons.arrowLeft,
          headerIconsSize: IconSizeScale.sm,
          headerIconsColor: AppColors.text,
          headerCurrentPageTextStyle: context.textTheme.headlineSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          headerSelectedIntervalTextStyle: context.textTheme.labelLarge
              ?.copyWith(color: AppColors.text),
        ),
        actionBarSettings: PickerActionBarSettings(
          actionBarPadding: .symmetric(
            horizontal: PaddingScale.lg,
            vertical: PaddingScale.md,
          ),
          buttonSpacing: SpacingScale.sm,
          confirmWidget: Text(
            context.localizations.save,
            style: context.textTheme.labelLarge,
          ),
          cancelWidget: Text(
            context.localizations.cancel,
            style: context.textTheme.labelLarge,
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          unselectedMonthsTextColor: context.colorExtension.unselectedTextColor,
          selectedMonthBackgroundColor: context.colorExtension.buttonMuted,
        ),
      ),
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(9000),
      initialDate: _controller.selectedDate.value ?? DateTime.now(),
    );

    if (picked != null) {
      _controller.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: .only(
        top: SpacingScale.sm,
        left: SpacingScale.lg,
        right: SpacingScale.lg,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const SizedBox(height: SpacingScale.lg),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                context.localizations.transactionHistory,
                style: context.textTheme.titleSmall,
              ),
              Obx(() {
                final isFilterActive = _controller.selectedDate.value != null;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidCalendar,
                            size: IconSizeScale.md,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: SpacingScale.sm),
                          Text(
                            _controller.formattedDate.value,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: isFilterActive ? AppColors.primary : null,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isFilterActive) ...[
                      const SizedBox(width: SpacingScale.sm),
                      GestureDetector(
                        onTap: () => _controller.setSelectedDate(null),
                        child: Icon(
                          Icons.close,
                          size: IconSizeScale.md,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: SpacingScale.xl),

          Obx(() {
            final groupedItems = _controller.groupedTransactions;
            final keys = groupedItems.keys.toList();

            if (keys.isEmpty) {
              return SizedBox(
                height: 230,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.clockRotateLeft,
                        size: IconSizeScale.xl,
                        color: context.colorExtension.textLabel,
                      ),
                      const SizedBox(height: SpacingScale.lg),
                      Text(
                        context.localizations.emptyHistory,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorExtension.textLabel,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: .only(bottom: SpacingScale.xl),
              shrinkWrap: true,
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final dateHeader = keys[index];
                final transactionList = groupedItems[dateHeader]!;

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(dateHeader, style: context.textTheme.titleSmall),
                    const SizedBox(height: SpacingScale.sm),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: .only(bottom: SpacingScale.xl),
                      shrinkWrap: true,
                      itemCount: transactionList.length,
                      itemBuilder: (context, index) {
                        final transaction = transactionList[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          onTap: () {
                            Get.toNamed(
                              '/transaction-detail/${transaction.id}',
                            );
                          },
                          child: TransactionCardWidget(
                            title: transaction.title,
                            category: transaction.categoryName ?? "",
                            amount: transaction.amount,
                            wallet: transaction.walletName ?? "",
                            type: transaction.type,
                            date: transaction.date,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: SpacingScale.md);
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: SpacingScale.xs);
              },
            );
          }),
        ],
      ),
    );
  }
}
