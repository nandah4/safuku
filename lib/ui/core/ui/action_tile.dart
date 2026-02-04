import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

class ActionTile extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  const ActionTile({
    super.key,
    required this.onTap,
    required this.label,
    this.icon,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      onTap: onTap,
      child: Container(
        padding: .symmetric(
          horizontal: PaddingScale.lg,
          vertical: PaddingScale.lg,
        ),
        decoration: BoxDecoration(
          color: context.colorExtension.bgCard,
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          border: Border.all(
            width: 1,
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),
        ),
        child: Row(
          children: [
            // Make sure the icon is using from FontAwesomeIcons
            Icon(
              icon ?? Icons.settings,
              size: IconSizeScale.sm,
              color: iconColor ?? AppColors.primary,
            ),
            SizedBox(width: SpacingScale.xl),
            Text(label, style: context.textTheme.labelLarge),
            Spacer(),
            trailing ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
