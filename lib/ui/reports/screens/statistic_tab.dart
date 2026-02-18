import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/reports/controllers/statistic_controller.dart';
import 'package:safuku/ui/reports/widgets/spending_breakdown_section.dart';
import 'package:safuku/ui/reports/widgets/weekly_overview_section.dart';

class StatisticTab extends StatelessWidget {
  StatisticTab({super.key});

  final StatisticController _controller = Get.find<StatisticController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(
          dialogBackgroundColor: context.colorScheme.surface,
          insetPadding: EdgeInsets.all(PaddingScale.lg),
        ),
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: AppColors.primary,
          nextIcon: FontAwesomeIcons.arrowRight,
          previousIcon: FontAwesomeIcons.arrowLeft,
          headerIconsSize: IconSizeScale.sm,
          headerIconsColor: AppColors.text,
          headerCurrentPageTextStyle: context.textTheme.headlineSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          headerSelectedIntervalTextStyle: context.textTheme.labelLarge
              ?.copyWith(color: AppColors.text),
        ),
        actionBarSettings: PickerActionBarSettings(
          actionBarPadding: EdgeInsets.symmetric(
            horizontal: PaddingScale.lg,
            vertical: PaddingScale.md,
          ),
          buttonSpacing: SpacingScale.sm,
          confirmWidget: Text(
            context.localizations.save,
            style: context.textTheme.labelLarge,
          ),
          cancelWidget: Text(
            context.localizations.cancel,
            style: context.textTheme.labelLarge,
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          unselectedMonthsTextColor: context.colorExtension.unselectedTextColor,
          selectedMonthBackgroundColor: context.colorExtension.buttonMuted,
        ),
      ),
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(9000),
      initialDate: _controller.selectedDate.value,
    );

    if (picked != null) {
      _controller.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: SpacingScale.sm,
        left: SpacingScale.lg,
        right: SpacingScale.lg,
        bottom: SpacingScale.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SpacingScale.lg),

          // Header: Title + Date picker
          Obx(() {
            final date = _controller.selectedDate.value;
            final formatted = DateFormat('MMMM yyyy').format(date);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.statistic,
                  style: context.textTheme.titleSmall,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidCalendar,
                        size: IconSizeScale.md,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: SpacingScale.sm),
                      Text(
                        formatted,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: SpacingScale.lg),

          // Sub-tab bar
          Obx(() {
            final selectedTab = _controller.selectedSubTab.value;

            return Container(
              height: ButtonHeightScale.tab,
              padding: .all(SpacingScale.xs),
              decoration: BoxDecoration(
                color: context.colorExtension.bgCard,
                border: Border.all(
                  color:
                      context.colorExtension.outlinedBorder ??
                      Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(BorderRadiusScale.md),
              ),
              child: Row(
                children: [
                  _buildTabButton(
                    context,
                    label: context.localizations.spending,
                    isSelected: selectedTab == 0,
                    onTap: () => _controller.setSubTab(0),
                  ),
                  _buildTabButton(
                    context,
                    label: context.localizations.weekly,
                    isSelected: selectedTab == 1,
                    onTap: () => _controller.setSubTab(1),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: SpacingScale.xl),

          // Tab content
          Obx(() {
            final selectedTab = _controller.selectedSubTab.value;
            if (selectedTab == 0) {
              return SpendingBreakdownSection();
            } else {
              return WeeklyOverviewSection();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(BorderRadiusScale.md - 2),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: isSelected ? AppColors.text : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
