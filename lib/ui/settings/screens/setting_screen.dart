import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/controllers/personalization_controller.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/action_tile.dart';
import 'package:safuku/ui/core/ui/currency_picker.dart';
import 'package:safuku/ui/core/ui/modal_delete_item.dart';
import 'package:safuku/ui/settings/controller/backup_controller.dart';
import 'package:safuku/ui/settings/controller/remove_data_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  // Language and Personalization
  final removeData = Get.find<PersonalizationRepository>();
  final personalizationController = Get.find<PersonalizationController>();

  // Backup
  final backupController = Get.find<BackupController>();

  // Remove Data
  final removeDataController = Get.find<RemoveDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          context.localizations.settings,
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: .symmetric(horizontal: SpacingScale.lg),
        child: Column(
          children: [
            const SizedBox(height: SpacingScale.lg),
            Obx(
              () => ActionTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    backgroundColor: context.colorScheme.surface,

                    builder: (context) {
                      return Padding(
                        padding: .only(
                          bottom:
                              MediaQuery.of(context).viewPadding.bottom + 10,
                          left: SpacingScale.md,
                          right: SpacingScale.md,
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              context.localizations.backupRestoreDescription,
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: .w400,
                              ),
                            ),
                            const SizedBox(height: SpacingScale.md),
                            ActionTile(
                              onTap: () {
                                Get.back();
                                backupController.backupDatabase();
                              },
                              icon: FontAwesomeIcons.database,
                              label: context.localizations.backup,
                            ),
                            const SizedBox(height: SpacingScale.sm),
                            ActionTile(
                              onTap: () {
                                Get.back();
                                backupController.restoreDatabase();
                              },
                              icon: FontAwesomeIcons.clockRotateLeft,
                              label: context.localizations.restore,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: backupController.isLoading.value
                    ? FontAwesomeIcons.spinner
                    : FontAwesomeIcons.database,
                label: context.localizations.backupRestore,
              ),
            ),

            const SizedBox(height: SpacingScale.md),

            PopupMenuButton<String>(
              borderRadius: BorderRadius.circular(SpacingScale.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SpacingScale.md),
                side: BorderSide(
                  color:
                      context.colorExtension.outlinedBorder ??
                      AppColors.outlinedBorderLight,
                ),
              ),
              color: context.colorScheme.surface,

              popUpAnimationStyle: AnimationStyle(
                duration: Duration(milliseconds: 500),
              ),
              onSelected: (value) {
                personalizationController.setLocale(value);
              },
              offset: const Offset(0, 65),
              itemBuilder: (context) {
                return [
                  ...personalizationController.languageList.map((language) {
                    return PopupMenuItem(
                      value: language.id,
                      child: Padding(
                        padding: .symmetric(horizontal: SpacingScale.sm),
                        child: Row(
                          children: [
                            Text(
                              language.flagIcon,
                              style: context.textTheme.labelLarge?.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: SpacingScale.md),
                            Text(
                              language.name,
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ];
              },
              child: ActionTile(
                icon: FontAwesomeIcons.language,
                label: context.localizations.language,
                trailing: Text(
                  personalizationController.locale.value.toString(),
                  style: context.textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: SpacingScale.md),
            ActionTile(
              onTap: () {
                currencyPicker(context, (currency) {
                  personalizationController.setCurrency(currency.symbol);
                });
              },
              icon: FontAwesomeIcons.bitcoinSign,
              label: context.localizations.currency,
              trailing: Obx(
                () => Text(
                  personalizationController.currencySymbol.value,
                  style: context.textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: SpacingScale.md),
            ActionTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  backgroundColor: context.colorScheme.surface,
                  builder: (context) {
                    return ModalDeleteItem(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      iconColor: AppColors.error,
                      title: context.localizations.data,
                      description: context.localizations.dataDescription,
                      onDelete: () {
                        removeDataController.removeData();
                      },
                    );
                  },
                );
              },
              icon: FontAwesomeIcons.trash,
              iconColor: AppColors.error,
              label: context.localizations.removeData,
            ),
          ],
        ),
      ),
    );
  }
}
