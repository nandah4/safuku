import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

void currencyPicker(BuildContext context, void Function(Currency) onSelect) {
  showCurrencyPicker(
    context: context,
    showFlag: true,
    showCurrencyName: true,
    showCurrencyCode: true,
    theme: CurrencyPickerThemeData(
      backgroundColor: context.colorScheme.surface,
      titleTextStyle: context.textTheme.labelLarge,
      flagSize: IconSizeScale.md * 2,
      inputDecoration: InputDecoration(
        fillColor: context.colorExtension.bgCard,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.primary),
        hintText: context.localizations.hintTextSearchCurrency,
        hintStyle: context.textTheme.labelLarge,
      ),
    ),
    onSelect: (Currency currency) {
      onSelect(currency);
    },
  );
}
