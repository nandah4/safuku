import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  final Gradient? button;
  final Color? buttonMuted;
  final Color? menuInactive;
  final Color? bgCard;
  final Color? outlinedBorder;
  final Color? unselectedTextColor;
  final Color? textPrimary;
  final Color? textLabel;

  ColorExtension({
    this.button,
    this.buttonMuted,
    this.menuInactive,
    this.bgCard,
    this.outlinedBorder,
    this.unselectedTextColor,
    this.textPrimary,
    this.textLabel,
  });

  @override
  ThemeExtension<ColorExtension> copyWith() {
    return ColorExtension(
      button: button,
      buttonMuted: buttonMuted,
      menuInactive: menuInactive,
      bgCard: bgCard,
      outlinedBorder: outlinedBorder,
      unselectedTextColor: unselectedTextColor,
      textPrimary: textPrimary,
      textLabel: textLabel,
    );
  }

  @override
  ThemeExtension<ColorExtension> lerp(
    covariant ThemeExtension<ColorExtension>? other,
    double t,
  ) {
    if (other is! ColorExtension) {
      return this;
    }

    return ColorExtension(
      button: Gradient.lerp(button, other.button, t),
      buttonMuted: Color.lerp(buttonMuted, other.buttonMuted, t),
      menuInactive: Color.lerp(menuInactive, other.menuInactive, t),
      bgCard: Color.lerp(bgCard, other.bgCard, t),
      outlinedBorder: Color.lerp(outlinedBorder, other.outlinedBorder, t),
      unselectedTextColor: Color.lerp(
        unselectedTextColor,
        other.unselectedTextColor,
        t,
      ),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textLabel: Color.lerp(textLabel, other.textLabel, t),
    );
  }
}

final colorExtensionLight = ColorExtension(
  button: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.gradientPrimaryStart, AppColors.primary],
  ),
  buttonMuted: AppColors.outlinedBorderLight,
  menuInactive: AppColors.iconLight,
  bgCard: AppColors.containerBackgroundLight,
  outlinedBorder: AppColors.outlinedBorderLight,
  unselectedTextColor: AppColors.textPrimaryLight,
  textPrimary: AppColors.textPrimaryLight,
  textLabel: AppColors.textLabelLight,
);

final colorExtensionDark = ColorExtension(
  button: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.gradientPrimaryStart, AppColors.primary],
  ),
  buttonMuted: AppColors.outlinedBorderDark,
  menuInactive: AppColors.iconDark,
  bgCard: AppColors.containerBackgroundDark,
  outlinedBorder: AppColors.outlinedBorderDark,
  unselectedTextColor: AppColors.textPrimaryDark,
  textPrimary: AppColors.textPrimaryDark,
  textLabel: AppColors.textLabelDark,
);
