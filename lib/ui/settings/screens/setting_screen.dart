import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/action_tile.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final removeData = Get.find<PersonalizationRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text('Settings', style: context.textTheme.titleLarge),
      ),
      body: Padding(
        padding: .symmetric(horizontal: SpacingScale.lg),
        child: Column(
          children: [
            const SizedBox(height: SpacingScale.lg),
            ActionTile(
              onTap: () {
                print("Backup and restore");
              },
              icon: FontAwesomeIcons.database,
              label: 'Backup and restore',
            ),
            const SizedBox(height: SpacingScale.md),
            ActionTile(
              onTap: () {
                print("Language");
              },
              icon: FontAwesomeIcons.language,
              label: 'Language',
              trailing: Text(
                "🇮🇩",
                style: context.textTheme.labelLarge?.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: SpacingScale.md),
            ActionTile(
              onTap: () {
                print("Currency");
              },
              icon: FontAwesomeIcons.bitcoinSign,
              label: 'Currency',
              trailing: Text("IDR", style: context.textTheme.labelLarge),
            ),
            const SizedBox(height: SpacingScale.md),
            ActionTile(
              onTap: () async {
                await removeData.clear();
                Get.offAllNamed('/');
                Get.updateLocale(const Locale('en'));
              },
              icon: FontAwesomeIcons.trash,
              iconColor: AppColors.error,
              label: 'Remove Data',
            ),
          ],
        ),
      ),
    );
  }
}
