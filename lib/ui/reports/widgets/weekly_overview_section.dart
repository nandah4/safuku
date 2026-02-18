import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:safuku/domain/entities/weekly_summary.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';
import 'package:safuku/ui/reports/controllers/statistic_controller.dart';

class WeeklyOverviewSection extends StatelessWidget {
  WeeklyOverviewSection({super.key});

  final StatisticController _controller = Get.find<StatisticController>();
  final FormatterInterface _formatter = Get.find<FormatterInterface>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weeklyData = _controller.weeklyBreakdown.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.weeklyOverview,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: SpacingScale.xl),

          if (weeklyData.isEmpty)
            _buildEmptyState(context)
          else ...[
            _buildBarChart(context, weeklyData),
            const SizedBox(height: SpacingScale.xl),
            _buildSummaryCards(context),
          ],
        ],
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
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

  Widget _buildBarChart(
    BuildContext context,
    List<WeeklySummaryEntity> weeklyData,
  ) {
    final maxAmount = weeklyData
        .map((e) => e.totalAmount)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    final maxY = maxAmount * 1.3;

    return Container(
      height: 230,
      padding: const EdgeInsets.all(PaddingScale.md),
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        borderRadius: BorderRadius.circular(BorderRadiusScale.xs),
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) =>
                  context.colorExtension.bgCard ?? Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  _formatter.formatAmountWithCurrency(rod.toY.toInt()),
                  context.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: PaddingScale.sm),
                    child: Text(
                      '${context.localizations.weekShort} ${value.toInt() + 1}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorExtension.textLabel,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: weeklyData.asMap().entries.map((entry) {
            final index = entry.key;
            final week = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: week.totalAmount.toDouble(),
                  color: AppColors.primary,
                  width: 32,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                label: context.localizations.total,
                value: _formatter.formatAmountWithCurrency(
                  _controller.totalWeeklyAmount,
                ),
              ),
            ),
            const SizedBox(width: SpacingScale.md),
            Expanded(
              child: _buildSummaryCard(
                context,
                label: context.localizations.averagePerWeek,
                value: _formatter.formatAmountWithCurrency(
                  _controller.averageWeeklyAmount,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingScale.md),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                label: context.localizations.highest,
                value:
                    "${context.localizations.week} ${_controller.highestWeekNumber}",
              ),
            ),
            const SizedBox(width: SpacingScale.md),
            Expanded(
              child: _buildSummaryCard(
                context,
                label: context.localizations.transactions,
                value: "${_controller.totalWeeklyTransactions}",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(PaddingScale.lg),
      decoration: BoxDecoration(
        color: context.colorExtension.bgCard,
        borderRadius: BorderRadius.circular(BorderRadiusScale.xs),
        border: Border.all(
          color: context.colorExtension.outlinedBorder ?? Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.labelMedium),
          const SizedBox(height: SpacingScale.sm),
          Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorExtension.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
