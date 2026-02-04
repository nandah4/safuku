import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyleCustom extends ThemeExtension<TextStyleCustom> {
  final TextStyle? currencyLarge;
  final TextStyle? currencyMedium;

  TextStyleCustom({this.currencyLarge, this.currencyMedium});

  @override
  TextStyleCustom copyWith({
    TextStyle? currencyLarge,
    TextStyle? currencyMedium,
  }) {
    return TextStyleCustom(
      currencyLarge: currencyLarge ?? this.currencyLarge,
      currencyMedium: currencyMedium ?? this.currencyMedium,
    );
  }

  @override
  ThemeExtension<TextStyleCustom> lerp(
    covariant ThemeExtension<TextStyleCustom>? other,
    double t,
  ) {
    if (other is! TextStyleCustom) {
      return this;
    }

    return TextStyleCustom(
      currencyLarge: TextStyle.lerp(currencyLarge, other.currencyLarge, t),
      currencyMedium: TextStyle.lerp(currencyMedium, other.currencyMedium, t),
    );
  }
}

final textStyleCustomLight = TextStyleCustom(
  currencyLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  ),
  currencyMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textLabelLight,
  ),
);

final textStyleCustomDark = TextStyleCustom(
  currencyLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  ),
  currencyMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textLabelDark,
  ),
);
