import 'package:intl/intl.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';

class Formatter {
  final PersonalizationRepository personalizationRepository;

  Formatter({required this.personalizationRepository});

  String formatAmountWithoutCurrency(int amount) {
    final convertToCurrency = NumberFormat('#,##0.00', 'en_US');
    return convertToCurrency.format(amount / 100);
  }

  String formatAmountWithCurrency(int amount) {
    final currency = formatAmountWithoutCurrency(amount);
    final currencySymbol = personalizationRepository.getString(key: 'currency');

    return "$currencySymbol $currency";
  }
}
