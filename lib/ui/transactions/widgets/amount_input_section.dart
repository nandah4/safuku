import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/error_label.dart';
import '../controllers/transaction_controller.dart';

/// Section widget for the amount input field.
class AmountInputSection extends StatelessWidget {
  final TransactionController controller;

  const AmountInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = controller.amountError.value.trim().isNotEmpty;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingScale.xl,
            vertical: PaddingScale.xl * 1.5,
          ),
          decoration: BoxDecoration(
            color: context.colorExtension.bgCard,
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : context.colorExtension.outlinedBorder ??
                        AppColors.outlinedBorderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.localizations.amount,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              const SizedBox(height: SpacingScale.xs),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [CurrencyInputFormatter()],
                autofocus: true,
                onChanged: (_) {
                  if (hasError) controller.amountError.value = "";
                },
                textAlign: TextAlign.center,
                controller: controller.amountController,
                style: context.textStyleExtension.currencyLarge,
                decoration: InputDecoration(
                  errorStyle: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.error,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "0",
                  hintStyle: context.textStyleExtension.currencyLarge,
                ),
              ),
              if (hasError) ErrorLabel(error: controller.amountError.value),
            ],
          ),
        ),
      );
    });
  }
}
