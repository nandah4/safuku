import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';

class Language {
  final String id;
  final String name;
  final String flagIcon;

  Language({required this.id, required this.name, required this.flagIcon});
}

class PersonalizationController extends GetxController {
  final PersonalizationRepository _repository;

  PersonalizationController({required PersonalizationRepository repository})
    : _repository = repository;

  final locale = const Locale('en').obs;
  final currencySymbol = ''.obs;

  final languageList = [
    Language(id: 'id', name: 'Indonesia', flagIcon: '🇮🇩'),
    Language(id: 'en', name: 'English', flagIcon: '🇬🇧'),
    Language(id: 'ja', name: 'Japanese', flagIcon: '🇯🇵'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
    _loadCurrency();
  }

  Future<void> _loadLocale() async {
    final language = _repository.getString(key: 'language');
    locale.value = Locale(language ?? 'en');
  }

  Future<void> _loadCurrency() async {
    final currency = _repository.getString(key: 'currency');
    currencySymbol.value = currency ?? 'Rp';
  }

  Future<void> setLocale(String id) async {
    await _repository.setString(key: 'language', value: id);
    locale.value = Locale(id);
    Get.updateLocale(Locale(id));
  }

  Future<void> setCurrency(String currency) async {
    await _repository.setString(key: 'currency', value: currency);
    currencySymbol.value = currency;
  }
}
