import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class WalletCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String balance;
  final Color color;

  const WalletCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.balance,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PaddingScale.xl),
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        borderRadius: BorderRadius.circular(BorderRadiusScale.md),
        border: Border.all(
          color: context.colorExtension.outlinedBorder ?? Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: IconSizeScale.md),
              const SizedBox(width: SpacingScale.sm),
              Text(title, style: context.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: SpacingScale.sm),

          Text(
            balance,
            style: context.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
