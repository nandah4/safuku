import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

class ItemDetail extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  const ItemDetail({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PaddingScale.lg),
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
        border: Border.all(
          color: context.colorExtension.outlinedBorder ?? Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: WalletCardSizeScale.widthAndHeight,
            height: WalletCardSizeScale.widthAndHeight,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
            ),
            child: Center(
              child: Icon(icon, size: IconSizeScale.md, color: iconColor),
            ),
          ),
          const SizedBox(width: SpacingScale.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorExtension.textLabel,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorExtension.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
