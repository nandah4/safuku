import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AddWalletWidget extends StatefulWidget {
  const AddWalletWidget({super.key});
  @override
  State<StatefulWidget> createState() => _AddWalleteWidget();
}

class _AddWalleteWidget extends State<AddWalletWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController amountController;
  late TextEditingController nameController;

  String? _amountError;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    super.dispose();
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
          // Header
          Padding(
            padding: .only(
              left: PaddingScale.lg,
              right: PaddingScale.lg,
              top: PaddingScale.sm,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: IconSizeScale.sm,
                  ),
                ),
                const SizedBox(width: SpacingScale.sm),
                Text("Add Wallet", style: context.textTheme.titleMedium),
              ],
            ),
          ),
          Divider(color: context.colorExtension.outlinedBorder),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .vertical,
              padding: .symmetric(
                horizontal: PaddingScale.lg,
                vertical: PaddingScale.md,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: .symmetric(
                        horizontal: PaddingScale.xl,
                        vertical: PaddingScale.xl * 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorExtension.bgCard,
                        borderRadius: .circular(BorderRadiusScale.sm),
                        border: Border.all(
                          color: _amountError != null
                              ? AppColors.error
                              : context.colorExtension.outlinedBorder ??
                                    AppColors.outlinedBorderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: .center,
                        children: [
                          Text(
                            "Amount",
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: SpacingScale.xs),
                          TextFormField(
                            keyboardType: .number,
                            autofocus: true,
                            onChanged: (value) {
                              if (_amountError != null) {
                                setState(() => _amountError = null);
                              }
                            },

                            textAlign: .center,
                            controller: amountController,
                            style: context.textStyleExtension.currencyLarge,
                            decoration: InputDecoration(
                              errorStyle: context.textTheme.labelLarge
                                  ?.copyWith(color: context.colorScheme.error),
                              border: .none,
                              enabledBorder: .none,
                              focusedBorder: .none,
                              disabledBorder: .none,
                              hintText: "0",
                              hintStyle:
                                  context.textStyleExtension.currencyLarge,
                            ),
                          ),
                          if (_amountError != null) ...[
                            const SizedBox(height: SpacingScale.md),
                            Text(
                              _amountError!,
                              style: context.textTheme.labelMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: SpacingScale.xl),
                    TextFormField(
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colorExtension.bgCard,
                        label: Text(
                          "Wallet name",
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.wallet,
                          size: IconSizeScale.md,
                          color: pickerColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(
                            color:
                                context.colorExtension.outlinedBorder ??
                                AppColors.outlinedBorderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(
                            color:
                                context.colorExtension.outlinedBorder ??
                                AppColors.outlinedBorderLight,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        errorStyle: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Wallet name is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SpacingScale.md),

                    Text(
                      "Wallet Color (Opsional)",
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: SpacingScale.sm),
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: pickerColor,
                            borderRadius: BorderRadius.circular(
                              BorderRadiusScale.sm,
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
                                    backgroundColor:
                                        context.colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        BorderRadiusScale.md,
                                      ),
                                    ),

                                    titleTextStyle:
                                        context.textTheme.titleLarge,
                                    title: const Text('Pick a color'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: currentColor,

                                        onColorChanged: changeColor,
                                        availableColors: [
                                          AppColors.error,
                                          AppColors.warning,
                                          AppColors.success,
                                          AppColors.primary,
                                          AppColors.secondary,
                                          AppColors.purplePicker,
                                          AppColors.lightGreenPicker,
                                          AppColors.pinkPicker,
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: context
                                              .colorExtension
                                              .textPrimary,
                                        ),
                                        child: Text(
                                          'Cancel',
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
                                          foregroundColor: context
                                              .colorExtension
                                              .textPrimary,
                                        ),
                                        child: Text(
                                          'Got it',
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
                              backgroundColor:
                                  context.colorExtension.buttonMuted,
                              elevation: 0,
                              shadowColor: Colors.transparent,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  BorderRadiusScale.sm,
                                ),
                                side: BorderSide(
                                  color:
                                      context.colorExtension.outlinedBorder ??
                                      AppColors.outlinedBorderLight,
                                ),
                              ),
                            ),
                            child: Text(
                              "Pick color",
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorExtension.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: SpacingScale.xl),
                    ButtonPrimary(
                      text: "Create Wallet",
                      onPressed: () {
                        if (amountController.text.trim().isEmpty) {
                          setState(
                            () => _amountError = "Please enter an amount",
                          );
                          return;
                        }

                        final validAmount = double.tryParse(
                          amountController.text.trim(),
                        );
                        if (validAmount == null || validAmount <= 0) {
                          setState(() {
                            setState(
                              () =>
                                  _amountError = "Please enter a valid amount",
                            );
                          });
                        }

                        if (_formKey.currentState!.validate()) {
                          context.pop();
                        }
                      },
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
}
