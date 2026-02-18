import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import '../controllers/category_controller.dart';

typedef OnCategorySelected = void Function(String);

class AddCategoryWidget extends StatelessWidget {
  final String selectedCategoryId;
  final OnCategorySelected onCategorySelected;
  AddCategoryWidget({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final CategoryController _categoryController = Get.find<CategoryController>();

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
                  onPressed: () => Get.back(),
                  icon: Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: IconSizeScale.sm,
                  ),
                ),
                const SizedBox(width: SpacingScale.sm),
                Text(
                  "${context.localizations.category} ",
                  style: context.textTheme.titleMedium,
                ),
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
                key: _categoryController.formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    TextFormField(
                      controller: _categoryController.categoryNameController,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textPrimary,
                      ),
                      maxLength: 30,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colorExtension.bgCard,
                        label: Text(
                          context.localizations.categoryHint,
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        counterStyle: context.textTheme.labelMedium,
                        prefixIcon: Icon(
                          FontAwesomeIcons.tag,
                          size: IconSizeScale.md,
                          color: context.colorScheme.primary,
                        ),
                        enabledBorder: _buildOutlineInputBorder(
                          context,
                          false,
                          context.colorExtension.outlinedBorder ??
                              AppColors.outlinedBorderLight,
                        ),
                        focusedBorder: _buildOutlineInputBorder(
                          context,
                          false,
                          context.colorScheme.primary,
                        ),
                        errorBorder: _buildOutlineInputBorder(
                          context,
                          true,
                          AppColors.error,
                        ),
                        focusedErrorBorder: _buildOutlineInputBorder(
                          context,
                          true,
                          AppColors.error,
                        ),
                        errorStyle: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.localizations.valCategoryRequired;
                        }
                        if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                          return context.localizations.valCategorySpecialChars;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SpacingScale.lg),
                    ButtonPrimary(
                      text: context.localizations.buttonCreateCategory,
                      onPressed: () {
                        if (_categoryController.formKey.currentState!
                            .validate()) {
                          _categoryController.createCategory(
                            _categoryController.categoryNameController.text
                                .trim(),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: SpacingScale.xl),

                    // All Categories
                    Text(
                      context.localizations.allCategories,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: SpacingScale.sm),
                    Obx(
                      () => Wrap(
                        spacing: SpacingScale.sm,
                        runSpacing: SpacingScale.sm,
                        children: [
                          ..._categoryController.categories.map((category) {
                            return GestureDetector(
                              onTap: () => {
                                onCategorySelected(category.id.toString()),
                                Get.back(),
                              },

                              child: SizedBox(
                                child: Container(
                                  padding: .symmetric(
                                    horizontal: PaddingScale.lg,
                                    vertical: PaddingScale.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colorExtension.bgCard,
                                    borderRadius: BorderRadius.circular(
                                      BorderRadiusScale.sm,
                                    ),
                                    border: Border.all(
                                      width:
                                          selectedCategoryId ==
                                              category.id.toString()
                                          ? 2
                                          : 1,
                                      color:
                                          selectedCategoryId ==
                                              category.id.toString()
                                          ? AppColors.primary
                                          : context
                                                    .colorExtension
                                                    .outlinedBorder ??
                                                AppColors.outlinedBorderLight,
                                    ),
                                  ),
                                  child: Text(
                                    category.name,
                                    style: context.textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
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

  OutlineInputBorder _buildOutlineInputBorder(
    BuildContext context,
    bool isSelected,
    Color? color,
  ) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      borderSide: BorderSide(
        width: isSelected ? 2 : 1,
        color: isSelected
            ? color ?? AppColors.primary
            : context.colorExtension.outlinedBorder ??
                  AppColors.outlinedBorderLight,
      ),
    );
  }
}
