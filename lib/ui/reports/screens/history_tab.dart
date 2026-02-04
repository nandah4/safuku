import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/modal_delete_item.dart';
import 'package:safuku/ui/core/ui/transaction_card_widget.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
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
          confirmWidget: Text("Confirm", style: context.textTheme.labelLarge),
          cancelWidget: Text("Cancel", style: context.textTheme.labelLarge),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          unselectedMonthsTextColor: context.colorExtension.unselectedTextColor,
          selectedMonthBackgroundColor: context.colorExtension.buttonMuted,
        ),
      ),
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(9000),
      initialDate: DateTime.now(),
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  String get _selectedDateString =>
      DateFormat("MMMM yyyy").format(_selectedDate ?? DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: .symmetric(horizontal: SpacingScale.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const SizedBox(height: SpacingScale.lg),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text("Transaction History", style: context.textTheme.titleSmall),
              GestureDetector(
                onTap: () {
                  _selectDate();
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.solidCalendar,
                      size: IconSizeScale.md,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: SpacingScale.sm),
                    Text(
                      _selectedDateString,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingScale.xl),

          Text("21 Desember 2026", style: context.textTheme.titleSmall),
          const SizedBox(height: SpacingScale.sm),
          InkWell(
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: context.screenSize.height * 0.9,
                ),
                builder: (context) {
                  return ModalDeleteItem(
                    iconColor: AppColors.error,
                    icon: FontAwesomeIcons.wallet,
                    title: "Delete Wallet",
                    description: "Are you sure you want to delete this wallet?",
                    onDelete: () {
                      print("Delete");
                    },
                  );
                },
              );
            },
            child: TransactionCardWidget(
              title: "Shopping",
              detail: "Book Store",
              amount: "Rp 100.000",
              wallet: "BNI",
              type: "expense",
            ),
          ),
          const SizedBox(height: SpacingScale.md),
          TransactionCardWidget(
            title: "Salary",
            detail: "Salary",
            amount: "Rp 100.000",
            wallet: "BRI",
            type: "income",
          ),
        ],
      ),
    );
  }
}
