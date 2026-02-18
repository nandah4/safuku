import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:safuku/ui/wallet/controllers/add_wallet_controller.dart';

final _availableColor = <Color>[
  AppColors.error,
  AppColors.warning,
  AppColors.success,
  AppColors.primary,
  AppColors.secondary,
  AppColors.purplePicker,
  AppColors.lightGreenPicker,
  AppColors.pinkPicker,
];

class AddWalletWidget extends StatelessWidget {
  AddWalletWidget({super.key});

  final AddWalletController controllers = Get.find<AddWalletController>();

  // Header modal
  Widget _headerModal(BuildContext context) {
    return Padding(
      padding: .only(
        left: PaddingScale.lg,
        right: PaddingScale.lg,
        top: PaddingScale.sm,
      ),
      child: Row(
        children: [
          IconButton(
            padding: .zero,
            onPressed: () => Get.back(),
            icon: Icon(FontAwesomeIcons.chevronLeft, size: IconSizeScale.sm),
          ),
          const SizedBox(width: SpacingScale.sm),
          Text(
            controllers.wallet != null
                ? context.localizations.updateWallet
                : context.localizations.addWallet,
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  // Section amount
  Widget _sectionAmount(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: .symmetric(
          horizontal: PaddingScale.xl,
          vertical: PaddingScale.xl * 1.5,
        ),
        decoration: BoxDecoration(
          color: context.colorExtension.bgCard,
          borderRadius: .circular(BorderRadiusScale.sm),
          border: Border.all(
            color: controllers.amountError.value != null
                ? AppColors.error
                : context.colorExtension.outlinedBorder ??
                      AppColors.outlinedBorderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Text(
              context.localizations.amount,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
            const SizedBox(height: SpacingScale.xs),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(),
              onChanged: (value) {
                if (controllers.amountError.value != null) {
                  controllers.amountError.value = null;
                }
                controllers.checkButtonDisabled();
              },
              inputFormatters: [CurrencyInputFormatter()],
              autofocus: true,
              textAlign: .center,
              controller: controllers.amountController,
              style: context.textStyleExtension.currencyLarge,
              decoration: InputDecoration(
                errorStyle: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.error,
                ),
                border: .none,
                enabledBorder: .none,
                focusedBorder: .none,
                disabledBorder: .none,
                hintText: "0",
                hintStyle: context.textStyleExtension.currencyLarge,
              ),
            ),
            if (controllers.amountError.value != null) ...[
              const SizedBox(height: SpacingScale.md),
              Text(
                controllers.amountError.value!,
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Field name
  Widget _sectionName(BuildContext context) {
    return TextFormField(
      controller: controllers.nameController,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorExtension.textPrimary,
      ),
      onChanged: (value) {
        controllers.checkButtonDisabled();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colorExtension.bgCard,
        label: Text(
          context.localizations.walletName,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixIcon: Obx(
          () => Icon(
            FontAwesomeIcons.wallet,
            size: IconSizeScale.md,
            color: controllers.currentColor.value,
          ),
        ),
        enabledBorder: _border(context: context),
        focusedBorder: _border(context: context),
        errorBorder: _border(context: context, color: AppColors.error),
        focusedErrorBorder: _border(context: context, color: AppColors.error),
        errorStyle: context.textTheme.labelMedium?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.localizations.walletNameRequired;
        }
        if (value.contains(RegExp(r'[^a-zA-Z0-9 ]'))) {
          return context.localizations.walletNameInvalid;
        }
        return null;
      },
    );
  }

  // Select color
  Widget _sectionSelectColor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localizations.walletColor,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: SpacingScale.sm),
        Row(
          children: [
            Obx(
              () => Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: controllers.currentColor.value,
                  borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
                ),
              ),
            ),
            const SizedBox(width: SpacingScale.md),
            SizedBox(
              height: 45,
              width: context.screenSize.width * .4,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: SpacingScale.md,
                        ),
                        backgroundColor: context.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.md,
                          ),
                        ),

                        titleTextStyle: context.textTheme.titleLarge,
                        title: Text(context.localizations.pickColor),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: controllers.currentColor.value,
                            onColorChanged: (value) {
                              controllers.setColor(value);
                            },
                            availableColors: _availableColor,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor:
                                  context.colorExtension.textPrimary,
                            ),
                            child: Text(
                              context.localizations.cancel,
                              style: context.textTheme.labelLarge,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor:
                                  context.colorExtension.textPrimary,
                            ),
                            child: Text(
                              context.localizations.save,
                              style: context.textTheme.labelLarge,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorExtension.buttonMuted,
                  elevation: 0,
                  shadowColor: Colors.transparent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
                    side: BorderSide(
                      color:
                          context.colorExtension.outlinedBorder ??
                          AppColors.outlinedBorderLight,
                    ),
                  ),
                ),
                child: Text(
                  context.localizations.pickColor,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorExtension.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .vertical(top: Radius.circular(BorderRadiusScale.lg)),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,

        children: [
          _headerModal(context),

          // Scrollable content (body)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .vertical,
              padding: .symmetric(
                horizontal: PaddingScale.lg,
                vertical: PaddingScale.xs,
              ),
              child: Form(
                key: controllers.formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _sectionAmount(context),
                    const SizedBox(height: SpacingScale.md),

                    _sectionName(context),
                    const SizedBox(height: SpacingScale.md),

                    _sectionSelectColor(context),

                    const SizedBox(height: SpacingScale.xl),

                    Obx(
                      () => ButtonPrimary(
                        text: controllers.wallet != null
                            ? context.localizations.updateWalletButton
                            : context.localizations.createWalletButton,
                        isDisabled: controllers.isButtonDisabled.value,
                        isLoading: controllers.isLoading.value,
                        onPressed: () {
                          if (controllers.formKey.currentState!.validate()) {
                            controllers.submitWallet();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border({required BuildContext context, Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      borderSide: BorderSide(
        color:
            color ??
            context.colorExtension.outlinedBorder ??
            AppColors.outlinedBorderLight,
      ),
    );
  }
}
