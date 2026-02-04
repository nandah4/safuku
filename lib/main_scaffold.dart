import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_secondary.dart';
import 'package:safuku/ui/core/ui/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [AppColors.primary, AppColors.gradientPrimaryStart],
          ),
          borderRadius: BorderRadius.circular(BorderRadiusScale.lg),
          border: Border.all(
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: context.colorScheme.surface,

                builder: (context) {
                  return Container(
                    width: .infinity,
                    padding: .only(
                      top: PaddingScale.xl,
                      bottom: PaddingScale.xl * 2,
                      left: PaddingScale.md,
                      right: PaddingScale.md,
                    ),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        const SizedBox(height: SpacingScale.md),
                        InkWell(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          onTap: () {
                            context.push('/add-transaction');
                            context.pop();
                          },
                          child: Padding(
                            padding: .all(PaddingScale.md),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.moneyBills,
                                  size: IconSizeScale.lg,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: SpacingScale.xl),
                                Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      "Add Transaction",
                                      style: context.textTheme.titleSmall,
                                    ),
                                    Text(
                                      "You can note your expanses or income.",
                                      style: context.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: SpacingScale.lg),

                        ButtonSecondary(
                          backgroundColor: Colors.transparent,
                          textColor: context.colorExtension.textPrimary,
                          text: "Cancel",

                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            borderRadius: BorderRadius.circular(BorderRadiusScale.lg),
            child: Icon(
              FontAwesomeIcons.plus,
              color: context.colorScheme.onPrimary,
              size: IconSizeScale.md,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: context.colorScheme.surface,
        notchMargin: 8.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: .spaceAround,
          children: [
            NavItem(
              navigationShell: navigationShell,
              index: 0,
              label: 'Home',
              iconInactive: FontAwesomeIcons.house,
              iconActive: FontAwesomeIcons.solidHouse,
            ),
            NavItem(
              navigationShell: navigationShell,
              index: 1,
              label: 'Wallet',
              iconInactive: FontAwesomeIcons.wallet,
            ),
            const SizedBox(width: 50),
            NavItem(
              navigationShell: navigationShell,
              index: 2,
              label: 'Reports',
              iconInactive: FontAwesomeIcons.clipboard,
              iconActive: FontAwesomeIcons.solidClipboard,
            ),
            NavItem(
              navigationShell: navigationShell,
              index: 3,
              label: 'Settings',
              iconInactive: FontAwesomeIcons.gear,
            ),
          ],
        ),
      ),
    );
  }
}
