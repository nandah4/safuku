import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';

class PersonalizationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isLanguageSelected = Get.find<PersonalizationRepository>().getString(
      key: 'language',
    );
    final isCurrencySelected = Get.find<PersonalizationRepository>().getString(
      key: 'currency',
    );

    if (isLanguageSelected == null) {
      return RouteSettings(name: '/onboard-language');
    }

    if (isCurrencySelected == null) {
      return RouteSettings(name: '/onboard-currency');
    }

    return null;
  }
}
