import 'package:intl/intl.dart';
import 'package:safuku/ui/core/controllers/personalization_controller.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';

class Formatter implements FormatterInterface {
  final PersonalizationController personalizationController;

  Formatter({required this.personalizationController});

  @override
  String formatAmountWithoutCurrency(int amount) {
    final convertToCurrency = NumberFormat('#,##0.00', 'en_US');
    return convertToCurrency.format(amount / 100);
  }

  @override
  String formatAmountWithCurrency(int amount) {
    final currency = formatAmountWithoutCurrency(amount);
    final currencySymbol = personalizationController.currencySymbol.value;

    return "$currencySymbol $currency";
  }
}
