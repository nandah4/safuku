import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

/// A error label widget used below form fields.
class ErrorLabel extends StatelessWidget {
  final String error;
  final EdgeInsetsGeometry? padding;

  const ErrorLabel({super.key, required this.error, this.padding});

  @override
  Widget build(BuildContext context) {
    if (error.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding ?? const EdgeInsets.only(top: SpacingScale.sm),
      child: Text(
        error,
        style: context.textTheme.labelMedium?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
