import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:safuku/ui/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

class OnboardCurrencyScreen extends StatefulWidget {
  const OnboardCurrencyScreen({super.key});

  @override
  State<OnboardCurrencyScreen> createState() => _OnboardCurrencyScreenState();
}

class _OnboardCurrencyScreenState extends State<OnboardCurrencyScreen> {
  Currency? _selectedCurrency = Currency(
    code: 'IDR',
    name: 'Indonesia',
    symbol: 'Rp',
    decimalDigits: 2,
    decimalSeparator: ',',
    thousandsSeparator: '.',
    flag: '🇮🇩',
    namePlural: 'Indonesia',
    number: 123456789,
    spaceBetweenAmountAndSymbol: true,
    symbolOnLeft: true,
  );

  @override
  void initState() {
    super.initState();
  }

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
                      'Choose your language',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: SpacingScale.xs),
                    Text(
                      'This will be used for all your expenses.',
                      style: context.textTheme.bodySmall,
                    ),
                    const SizedBox(height: SpacingScale.lg * 2),
                    SizedBox(
                      height: ButtonHeightScale.primary,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingScale.md,
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
                                Text(
                                  _selectedCurrency?.symbol ?? 'Rp',
                                  style: context.textTheme.labelLarge,
                                ),
                                const SizedBox(width: SpacingScale.sm),
                                Text(
                                  _selectedCurrency?.code ?? 'IDR',
                                  style: context.textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: SpacingScale.lg),
                          Expanded(
                            child: ButtonPrimary(
                              isDisabled: false,
                              onPressed: () {
                                showCurrencyPicker(
                                  context: context,
                                  showFlag: true,
                                  showCurrencyName: true,
                                  showCurrencyCode: true,
                                  theme: CurrencyPickerThemeData(
                                    backgroundColor:
                                        context.colorScheme.surface,
                                    titleTextStyle:
                                        context.textTheme.labelLarge,
                                    flagSize: IconSizeScale.md * 2,
                                    inputDecoration: InputDecoration(
                                      fillColor: context.colorExtension.bgCard,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          BorderRadiusScale.sm,
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              context
                                                  .colorExtension
                                                  .outlinedBorder ??
                                              AppColors.outlinedBorderDark,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          BorderRadiusScale.sm,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.primary,
                                      ),
                                      hintText: 'Search currency',
                                      hintStyle: context.textTheme.labelLarge,
                                    ),
                                  ),
                                  onSelect: (Currency currency) {
                                    setState(() {
                                      _selectedCurrency = currency;
                                    });
                                  },
                                );
                              },
                              text: 'Select Currency',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                isDisabled: _selectedCurrency == null,
                text: "Continue",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
