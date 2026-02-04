import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class ButtonSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDisabled;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isBorder;
  const ButtonSecondary({
    super.key,
    this.onPressed,
    required this.text,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ButtonHeightScale.primary,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colorExtension.buttonMuted,
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          border: isBorder
              ? Border.all(color: borderColor ?? Colors.transparent)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              overlayColor: context.colorExtension.buttonMuted,
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
                fontWeight: FontWeight.w500,
                color: isDisabled
                    ? context.colorScheme.onSurface
                    : textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
