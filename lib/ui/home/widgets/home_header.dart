import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/utils/formatter.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';
import 'package:safuku/ui/home/widgets/wallet_card_widget.dart';
import 'package:safuku/ui/wallet/controllers/wallet_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key});

  final HomeController _homeController = Get.find<HomeController>();
  final WalletController _walletController = Get.find<WalletController>();
  final Formatter _Formatter = Get.find<Formatter>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 295,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: .75),
                AppColors.primary,
              ],
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          minimum: EdgeInsets.symmetric(horizontal: PaddingScale.lg),
          child: Column(
            children: [
              const SizedBox(height: 75),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.localizations.labelCurrentBalance,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            _homeController.isBalanceVisible.value
                                ? _Formatter.formatAmountWithoutCurrency(
                                    _walletController.totalSaldo.value,
                                  )
                                : "*******",
                            style: context.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          );
                        }),
                        const SizedBox(width: SpacingScale.xs),
                        IconButton(
                          onPressed: () {
                            _homeController.setBalanceVisible(
                              !_homeController.isBalanceVisible.value,
                            );
                          },
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: Colors.white,
                            size: IconSizeScale.sm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingScale.md),
                    Text(
                      "- 0,80 %  ${context.localizations.thanLastWeek}",
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SpacingScale.xl * 2),
                    Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: WalletCardWidget(
                              balance: _Formatter.formatAmountWithCurrency(
                                _homeController
                                    .transactionTypePerMonth
                                    .value
                                    .income,
                              ),
                              color: AppColors.success,
                              icon: FontAwesomeIcons.wallet,
                              title: context.localizations.labelIncome,
                            ),
                          ),
                          const SizedBox(width: SpacingScale.sm),
                          Expanded(
                            child: WalletCardWidget(
                              balance: _Formatter.formatAmountWithCurrency(
                                _homeController
                                    .transactionTypePerMonth
                                    .value
                                    .expense,
                              ),
                              color: AppColors.error,
                              icon: FontAwesomeIcons.wallet,
                              title: context.localizations.labelExpense,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
