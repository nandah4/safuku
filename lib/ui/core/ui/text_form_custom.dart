import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

class TextFormCustom extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String labelText;
  final TextEditingController controller;
  const TextFormCustom({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: .text,
      controller: controller,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorExtension.textPrimary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colorExtension.bgCard,
        label: Text(
          labelText,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixIcon: Icon(icon, size: IconSizeScale.md, color: iconColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        errorStyle: context.textTheme.labelMedium?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.localizations.fieldRequired(labelText);
        }
        return null;
      },
    );
  }
}
