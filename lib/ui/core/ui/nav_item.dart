import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final VoidCallback? onTap;
  final int currentIndex;
  final int navIndex;
  final String label;
  final IconData iconInactive;
  final IconData? iconActive;

  const NavItem({
    super.key,
    this.onTap,
    required this.currentIndex,
    required this.navIndex,
    required this.label,
    required this.iconInactive,
    this.iconActive,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentIndex == navIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      splashColor: context.colorExtension.bgCard,
      highlightColor: context.colorExtension.bgCard,
      onTap: onTap,
      child: Padding(
        padding: .symmetric(
          vertical: PaddingScale.xs,
          horizontal: PaddingScale.md,
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Icon(
              isActive ? iconActive ?? iconInactive : iconInactive,
              size: IconSizeScale.md,
              color: isActive
                  ? context.colorScheme.primary
                  : context.colorExtension.menuInactive,
            ),
            const SizedBox(height: SpacingScale.sm),
            Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive
                    ? context.colorScheme.primary
                    : context.colorExtension.menuInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
