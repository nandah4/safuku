import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:safuku/domain/entities/category_spending.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';
import 'package:safuku/ui/reports/controllers/statistic_controller.dart';

class SpendingBreakdownSection extends StatelessWidget {
  SpendingBreakdownSection({super.key});

  final StatisticController _controller = Get.find<StatisticController>();
  final FormatterInterface _formatter = Get.find<FormatterInterface>();

  static const List<Color> chartColors = [
    Color(0xFF01AEEE),
    Color(0xFFFF9B2F),
    Color(0xFF685AFF),
    Color(0xFF009C00),
    Color(0xFFF075AE),
    Color(0xFFBBCB2E),
    Color(0xFFFF3333),
    Color(0xFFFFD700),
  ];

  Color _getColor(int index) {
    return chartColors[index % chartColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = _controller.categorySpending.value;
      final filterType = _controller.filterType.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.spendingBreakdown,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorExtension.textPrimary,
                ),
              ),
              _buildFilterChip(context, filterType),
            ],
          ),
          const SizedBox(height: SpacingScale.xl),

          // Chart or empty state
          if (categories.isEmpty)
            _buildEmptyState(context)
          else ...[
            _buildDonutChart(context, categories),
            _buildCategoryList(context, categories),
          ],
        ],
      );
    });
  }

  Widget _buildFilterChip(BuildContext context, String currentFilter) {
    return PopupMenuButton<String>(
      borderRadius: BorderRadius.circular(BorderRadiusScale.xs),
      onSelected: (value) => _controller.setFilterType(value),
      color: context.colorExtension.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BorderRadiusScale.xs),
      ),
      offset: const Offset(0, 45),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'expense',
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: currentFilter == 'expense'
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              const SizedBox(width: SpacingScale.sm),
              Text(
                context.localizations.labelExpense,
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'income',
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: currentFilter == 'income'
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              const SizedBox(width: SpacingScale.sm),
              Text(
                context.localizations.labelIncome,
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingScale.lg,
          vertical: PaddingScale.sm,
        ),
        decoration: BoxDecoration(
          color: context.colorExtension.bgCard,
          border: Border.all(
            color:
                context.colorExtension.outlinedBorder ??
                AppColors.outlinedBorderLight,
          ),

          borderRadius: BorderRadius.circular(BorderRadiusScale.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentFilter == 'expense'
                  ? context.localizations.labelExpense
                  : context.localizations.labelIncome,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: SpacingScale.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: IconSizeScale.sm,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 48,
              color: context.colorExtension.textLabel,
            ),
            const SizedBox(height: SpacingScale.md),
            Text(
              context.localizations.noDataThisMonth,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorExtension.textLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(
    BuildContext context,
    List<CategorySpendingEntity> categories,
  ) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      ),

      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 75,
              sections: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return PieChartSectionData(
                  color: _getColor(index),
                  value: category.percentage,
                  title: '${category.percentage.toStringAsFixed(0)}%',
                  titleStyle: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 45,
                );
              }).toList(),
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          // Center total
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatter.formatAmountWithCurrency(_controller.totalSpending),
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorExtension.textPrimary,
                ),
              ),
              Text(
                context.localizations.totalAmount,
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<CategorySpendingEntity> categories,
  ) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingScale.lg,
            vertical: PaddingScale.lg,
          ),
          decoration: BoxDecoration(
            color: context.colorExtension.bgCard,
            border: Border.all(
              color:
                  context.colorExtension.outlinedBorder ??
                  AppColors.outlinedBorderLight,
            ),
            borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Category name
                  Expanded(
                    child: Text(
                      category.categoryName,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Amount
                  Text(
                    _formatter.formatAmountWithCurrency(category.totalAmount),
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingScale.lg),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: categories[index].percentage / 100,
                  backgroundColor: context.colorExtension.buttonMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(_getColor(index)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: SpacingScale.sm);
      },
    );
  }
}
