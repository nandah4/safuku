import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int index;
  final String label;
  final IconData iconInactive;
  final IconData? iconActive;

  const NavItem({
    super.key,
    required this.navigationShell,
    required this.index,
    required this.label,
    required this.iconInactive,
    this.iconActive,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = navigationShell.currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      splashColor: context.colorExtension.bgCard,
      highlightColor: context.colorExtension.bgCard,
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
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
