import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:safuku/ui/core/utils/formatter.dart';
import 'package:safuku/ui/core/utils/truncation_text.dart';

class TransactionCardWidget extends StatelessWidget {
  final IconData? icon;
  final String category;
  final String? title;
  final int amount;
  final DateTime? date;
  final String wallet;
  final String type;
  const TransactionCardWidget({
    super.key,
    this.icon,
    required this.category,
    this.title,
    required this.amount,
    this.date,
    required this.wallet,
    required this.type,
  });

  Color get _backgroundIconColor => type == "income"
      ? AppColors.successBackground
      : AppColors.errorBackground;
  Color get _iconColor =>
      type == "income" ? AppColors.success : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(PaddingScale.xl),
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        border: Border.all(
          color:
              context.colorExtension.outlinedBorder ??
              AppColors.outlinedBorderDark,
        ),
        borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      ),
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                height: WalletCardSizeScale.widthAndHeight,
                width: WalletCardSizeScale.widthAndHeight,
                decoration: BoxDecoration(
                  color: _backgroundIconColor,
                  borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.moneyBill,
                    size: IconSizeScale.md,
                    color: _iconColor,
                  ),
                ),
              ),
              const SizedBox(width: SpacingScale.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Text(
                          truncateText(category, 13),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colorExtension.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Get.find<Formatter>().formatAmountWithCurrency(
                            amount,
                          ),
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: type == "income"
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: SpacingScale.xs),
                    Text(
                      truncateText(title ?? '-', 20),
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingScale.sm),
          Divider(color: context.colorExtension.outlinedBorder, thickness: 1),
          const SizedBox(height: SpacingScale.sm),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.wallet,
                    size: IconSizeScale.sm,
                    color: context.colorExtension.textLabel,
                  ),
                  const SizedBox(width: SpacingScale.sm),
                  Text(
                    wallet,
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.solidCalendar,
                    size: IconSizeScale.sm,
                    color: context.colorExtension.textLabel,
                  ),
                  const SizedBox(width: SpacingScale.sm),
                  Text(
                    DateFormat("MMMM yyyy").format(date ?? DateTime.now()),
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
