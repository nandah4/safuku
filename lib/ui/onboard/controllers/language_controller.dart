import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';

class LanguageController extends GetxController {
  final _repository = Get.find<PersonalizationRepository>();

  final locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final language = await _repository.getString(key: 'language');
    locale.value = Locale(language ?? 'en');
  }
}
