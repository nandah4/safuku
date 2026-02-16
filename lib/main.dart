import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/bindings/initial_bindings.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:safuku/routing/router.dart';
import 'package:safuku/ui/core/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _init();
  runApp(MyApp());
}

Future<void> _init() async {
  await DatabaseHelper.instance.database;
  await InitialBinding.init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String savedLanguage =
      Get.find<PersonalizationRepository>().getString(key: 'language') ?? 'en';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safuku',
      theme: ligtTheme,
      darkTheme: darkTheme,
      locale: Locale(savedLanguage),
      fallbackLocale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      getPages: routerPage,
    );
  }
}
