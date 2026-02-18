import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/ui/core/controllers/shell_controller.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_secondary.dart';
import 'package:safuku/ui/core/ui/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safuku/ui/home/screens/home_screen.dart';
import 'package:safuku/ui/reports/screens/report_screen.dart';
import 'package:safuku/ui/settings/screens/setting_screen.dart';
import 'package:safuku/ui/wallet/screens/wallet_screen.dart';

class MainScaffold extends StatelessWidget {
  final ShellController _shellController = Get.find<ShellController>();

  MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: _shellController.currentIndex,
          children: [
            HomeScreen(),
            WalletScreen(),
            const ReportScreen(),
            SettingScreen(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 50,
        height: 50,
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
                            Get.back();
                            Get.toNamed('/add-transaction');
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.localizations.addTransaction,
                                        style: context.textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        context
                                            .localizations
                                            .youCanRecordExpensesAndIncome,
                                        style: context.textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: SpacingScale.lg),

                        ButtonSecondary(
                          backgroundColor: Colors.transparent,
                          textColor: context.colorExtension.textPrimary,
                          text: context.localizations.cancel,

                          onPressed: () => Get.back(),
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
        child: Obx(
          () => Row(
            mainAxisAlignment: .spaceAround,
            children: [
              NavItem(
                currentIndex: _shellController.currentIndex,
                navIndex: 0,
                label: context.localizations.bottomHome,
                iconInactive: FontAwesomeIcons.house,
                iconActive: FontAwesomeIcons.solidHouse,
                onTap: () {
                  _shellController.changeIndex(0);
                },
              ),
              NavItem(
                currentIndex: _shellController.currentIndex,
                navIndex: 1,
                label: context.localizations.bottomWallet,
                iconInactive: FontAwesomeIcons.wallet,
                onTap: () => _shellController.changeIndex(1),
              ),
              const SizedBox(width: 40),
              NavItem(
                currentIndex: _shellController.currentIndex,
                navIndex: 2,
                label: context.localizations.bottomReports,
                iconInactive: FontAwesomeIcons.clipboard,
                iconActive: FontAwesomeIcons.solidClipboard,
                onTap: () => _shellController.changeIndex(2),
              ),
              NavItem(
                currentIndex: _shellController.currentIndex,
                navIndex: 3,
                label: context.localizations.bottomSettings,
                iconInactive: FontAwesomeIcons.gear,
                onTap: () => _shellController.changeIndex(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
