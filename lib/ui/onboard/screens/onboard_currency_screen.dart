import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/ui/core/controllers/personalization_controller.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:safuku/ui/core/ui/currency_picker.dart';

class OnboardCurrencyScreen extends StatelessWidget {
  OnboardCurrencyScreen({super.key});

  final PersonalizationController _personalizationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/onboard-asset-currency.png',
                        width: ImageSizeScale.onboard,
                      ),
                    ),
                    const SizedBox(height: SpacingScale.sm),
                    Text(
                      context.localizations.chooseCurrency,
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: SpacingScale.xs),
                    SizedBox(
                      width: context.screenSize.width * .85,
                      child: Text(
                        textAlign: .center,
                        context.localizations.changeCurrencyAnytime,
                        style: context.textTheme.bodySmall?.copyWith(
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: SpacingScale.lg * 2),
                    SizedBox(
                      height: ButtonHeightScale.primary,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingScale.xl,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: context.colorExtension.bgCard,
                              borderRadius: BorderRadius.circular(
                                BorderRadiusScale.sm,
                              ),
                              border: Border.all(
                                color:
                                    context.colorExtension.outlinedBorder ??
                                    AppColors.outlinedBorderDark,
                              ),
                            ),
                            child: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    _personalizationController
                                                .currencySymbol
                                                .value ==
                                            ''
                                        ? '...'
                                        : _personalizationController
                                              .currencySymbol
                                              .value,
                                    style: context.textTheme.labelLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: SpacingScale.lg),
                          Expanded(
                            child: ButtonPrimary(
                              isDisabled: false,
                              onPressed: () {
                                currencyPicker(context, (currency) {
                                  _personalizationController.setCurrency(
                                    currency.symbol,
                                  );
                                });
                              },
                              text: context.localizations.selectCurrencyButton,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                isDisabled:
                    _personalizationController.currencySymbol.value == '',
                text: context.localizations.continueButton,
                onPressed: () {
                  if (_personalizationController.currencySymbol.value != '') {
                    _personalizationController.setCurrency(
                      _personalizationController.currencySymbol.value,
                    );

                    Get.offAllNamed('/');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
