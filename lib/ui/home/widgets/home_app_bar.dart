import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';

class HomeAppBar extends StatelessWidget {
  HomeAppBar({super.key});

  final HomeController _homeController = Get.find<HomeController>();

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
          actionBarPadding: .symmetric(
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
      initialDate: _homeController.selectedDate.value,
    );

    if (picked != null) {
      _homeController.setSelectedDate(picked);
    }
  }

  String get _selectedDateString =>
      DateFormat("MMMM yyyy").format(_homeController.selectedDate.value);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: PaddingScale.md,
          right: PaddingScale.md,
        ),
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        color: _homeController.isScrolled.value
            ? context.colorScheme.surface
            : Colors.transparent,
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.solidCalendar,
                size: IconSizeScale.md,
                color: _homeController.isScrolled.value
                    ? AppColors.primary
                    : AppColors.text,
              ),
              const SizedBox(width: SpacingScale.sm),
              Text(
                _selectedDateString,
                style: context.textTheme.labelLarge?.copyWith(
                  color: _homeController.isScrolled.value
                      ? context.colorExtension.textLabel
                      : AppColors.text,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
