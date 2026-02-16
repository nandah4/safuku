import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_dimens.dart';
import '../../core/themes/extensions/theme_extension.dart';
import '../../core/ui/action_tile.dart';
import '../../core/ui/button_primary.dart';
import '../../core/ui/text_form_custom.dart';
import '../controllers/category_controller.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/amount_input_section.dart';
import '../widgets/transaction_type_selector.dart';
import '../widgets/wallet_selector.dart';
import '../widgets/category_selector.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final TransactionController _transactionController =
      Get.find<TransactionController>();

  final CategoryController _categoryController = Get.find<CategoryController>();

  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        okButton: Text(
          context.localizations.save,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorExtension.textPrimary,
          ),
        ),
        cancelButton: Text(
          context.localizations.cancel,
          style: context.textTheme.labelLarge,
        ),
      ),
      dialogSize: const Size(325, 400),
      value: [_transactionController.selectedDate.value],
      borderRadius: BorderRadius.circular(15),
      dialogBackgroundColor: context.colorScheme.surface,
      useSafeArea: true,
    );

    if (picked != null) {
      _transactionController.selectedDate.value = picked.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              size: IconSizeScale.sm,
            ),
          ),
          centerTitle: false,
          title: Text("Add Transaction", style: context.textTheme.titleLarge),
          surfaceTintColor: context.colorScheme.surface,
          backgroundColor: context.colorScheme.surface,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _transactionController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                AmountInputSection(controller: _transactionController),
                const SizedBox(height: SpacingScale.xl),

                // Transaction Type
                TransactionTypeSelector(controller: _transactionController),
                const SizedBox(height: SpacingScale.lg),

                // Wallet
                WalletSelector(controller: _transactionController),
                const SizedBox(height: SpacingScale.lg),

                // Category
                CategorySelector(
                  transactionController: _transactionController,
                  categoryController: _categoryController,
                ),
                const SizedBox(height: SpacingScale.lg),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingScale.lg,
                  ),
                  child: TextFormCustom(
                    icon: Icons.title,
                    controller: _transactionController.nameController,
                    iconColor: AppColors.primary,
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: SpacingScale.lg),

                // Date
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingScale.lg,
                  ),
                  child: Obx(
                    () => ActionTile(
                      onTap: () => _selectDate(context),
                      icon: Icons.calendar_today,
                      label: _transactionController.formattedDate,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.lg),

                // Notes
                _buildNotesField(context),
                const SizedBox(height: SpacingScale.xl),

                // Submit
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingScale.lg,
                  ),
                  child: Obx(() {
                    return ButtonPrimary(
                      text: "Add Transaction",
                      isLoading: _transactionController.isLoading.value,
                      onPressed: _transactionController.isLoading.value
                          ? null
                          : () => _transactionController.submitTransaction(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    final borderColor =
        context.colorExtension.outlinedBorder ?? AppColors.outlinedBorderLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
      child: TextFormField(
        controller: _transactionController.notesController,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          ),
          filled: true,
          fillColor: context.colorExtension.bgCard,
          alignLabelWithHint: true,
          labelText: "Notes (optional)",
          labelStyle: context.textTheme.labelLarge,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          ),
        ),
      ),
    );
  }
}
