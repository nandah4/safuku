import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/error_label.dart';
import 'package:safuku/ui/core/ui/selectable_chip.dart';
import 'package:safuku/ui/core/utils/truncation_text.dart';
import '../controllers/category_controller.dart';
import '../controllers/transaction_controller.dart';
import 'add_category_widget.dart';

/// Maximum number of categories visible before showing the "add" button.
const int _maxVisibleCategories = 2;

/// Section widget for selecting a category.
class CategorySelector extends StatelessWidget {
  final TransactionController transactionController;
  final CategoryController categoryController;

  const CategorySelector({
    super.key,
    required this.transactionController,
    required this.categoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
          child: Text(
            context.localizations.category,
            style: context.textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: SpacingScale.sm),
        Obx(() {
          final categories = categoryController.categories;
          // Read categoryId here so Obx track it
          final selectedCategoryId = transactionController.categoryId.value;

          if (categories.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
              child: SizedBox(
                width: 60,
                height: 50,
                child: _addCategoryButton(context),
              ),
            );
          }

          final visibleCount = categories.length > _maxVisibleCategories
              ? _maxVisibleCategories + 1
              : categories.length + 1;

          return SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
              scrollDirection: Axis.horizontal,
              itemCount: visibleCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: SpacingScale.md),
              itemBuilder: (context, index) {
                // Show add button as the last item
                if (index == visibleCount - 1) {
                  return _addCategoryButton(context);
                }

                final category = categories[index];
                final isSelected = selectedCategoryId == category.id.toString();

                return SelectableChip(
                  isSelected: isSelected,
                  onTap: () {
                    transactionController.categoryId.value = category.id
                        .toString();
                    transactionController.categoryError.value = "";
                  },
                  child: Text(
                    truncateText(category.name, 11),
                    style: context.textTheme.labelMedium,
                  ),
                );
              },
            ),
          );
        }),
        Obx(() {
          if (transactionController.categoryError.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
            child: ErrorLabel(error: transactionController.categoryError.value),
          );
        }),
      ],
    );
  }

  Widget _addCategoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: context.screenSize.height * 0.92,
          ),
          builder: (context) {
            return AddCategoryWidget(
              selectedCategoryId: transactionController.categoryId.value,
              onCategorySelected: (id) {
                transactionController.categoryId.value = id;
                transactionController.categoryError.value = "";
              },
            );
          },
        ).whenComplete(() {
          categoryController.getCategories();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
        decoration: BoxDecoration(
          color: context.colorExtension.bgCard,
          borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          border: Border.all(
            width: 1,
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),
        ),
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }
}
