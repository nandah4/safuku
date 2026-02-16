import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/error_label.dart';
import 'package:safuku/ui/core/ui/selectable_chip.dart';
import '../controllers/transaction_controller.dart';

/// Section widget for selecting transaction type (income/expense).
class TransactionTypeSelector extends StatelessWidget {
  final TransactionController controller;

  const TransactionTypeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transaction Type", style: context.textTheme.titleSmall),
            const SizedBox(height: SpacingScale.sm),
            Row(
              children: [
                _buildTypeChip(
                  context,
                  "income",
                  "Income",
                  AppColors.success,
                  AppColors.successBackground,
                ),
                const SizedBox(width: SpacingScale.md),
                _buildTypeChip(
                  context,
                  "expense",
                  "Expense",
                  AppColors.error,
                  AppColors.errorBackground,
                ),
              ],
            ),
            if (controller.transactionTypeError.value.isNotEmpty)
              ErrorLabel(error: controller.transactionTypeError.value),
          ],
        );
      }),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    String type,
    String label,
    Color textColor,
    Color backgroundColor,
  ) {
    final isSelected = controller.transactionType.value == type;

    return Expanded(
      child: SelectableChip(
        isSelected: isSelected,
        selectedBorderColor: textColor,
        selectedBackgroundColor: backgroundColor,
        onTap: () {
          controller.transactionType.value = type;
          controller.transactionTypeError.value = "";
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: PaddingScale.lg),
          child: Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? textColor
                  : context.colorExtension.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
