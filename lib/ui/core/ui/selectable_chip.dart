import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

/// A chip widget that visually indicates whether it is selected or not.
class SelectableChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final Color? selectedBorderColor;
  final Color? selectedBackgroundColor;

  const SelectableChip({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.selectedBorderColor,
    this.selectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeBorderColor = selectedBorderColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedBackgroundColor ?? context.colorExtension.bgCard)
              : context.colorExtension.bgCard,
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          border: Border.all(
            width: isSelected ? 2 : 1,
            color: isSelected
                ? activeBorderColor
                : context.colorExtension.outlinedBorder ??
                      AppColors.outlinedBorderLight,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
