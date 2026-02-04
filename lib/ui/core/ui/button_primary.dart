import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDisabled;
  final String text;
  const ButtonPrimary({
    super.key,
    this.onPressed,
    required this.text,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ButtonHeightScale.primary,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  colors: [AppColors.gradientPrimaryStart, AppColors.primary],
                ),

          color: isDisabled ? context.colorExtension.buttonMuted : null,
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
              ),
            ),
            child: Text(
              text,
              style: context.textTheme.labelLarge?.copyWith(
                color: isDisabled
                    ? context.colorScheme.onSurface
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
