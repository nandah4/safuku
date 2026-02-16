import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_secondary.dart';

class ModalDeleteItem extends StatelessWidget {
  final VoidCallback onDelete;
  final IconData icon;
  final String title;
  final String? description;
  final Color? iconColor;
  final double iconSize;
  final double? backgroundIconSize;

  const ModalDeleteItem({
    super.key,
    required this.onDelete,
    required this.icon,
    required this.title,
    this.description,
    this.iconColor,
    this.iconSize = IconSizeScale.lg,
    this.backgroundIconSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .only(
        top: PaddingScale.xl,
        bottom: PaddingScale.xl * 2,
        left: PaddingScale.md,
        right: PaddingScale.md,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .only(
          topLeft: Radius.circular(BorderRadiusScale.md),
          topRight: Radius.circular(BorderRadiusScale.md),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          const SizedBox(height: SpacingScale.xl),
          Container(
            width: backgroundIconSize,
            height: backgroundIconSize,
            decoration: BoxDecoration(
              color:
                  iconColor?.withValues(alpha: 0.1) ??
                  AppColors.gradientPrimaryStart,
              borderRadius: .circular(BorderRadiusScale.sm),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: SpacingScale.lg),
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          const SizedBox(height: SpacingScale.md),
          Text(
            description ?? "Are you sure you want to delete this wallet?",
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          const SizedBox(height: SpacingScale.lg),
          ButtonSecondary(
            text: "Delete",
            backgroundColor: Colors.transparent,
            onPressed: onDelete,
            textColor: AppColors.error,
            isBorder: false,
          ),
          ButtonSecondary(
            text: "Cancel",
            backgroundColor: Colors.transparent,
            onPressed: () {
              Get.back();
            },
            textColor: context.colorExtension.textPrimary,
            isBorder: false,
          ),
        ],
      ),
    );
  }
}
