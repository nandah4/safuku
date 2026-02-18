import 'package:safuku/l10n/app_localizations.dart';

class AmountValidator {
  /// Convert string amount to int
  /// Example: "100.000,00" -> 100000000
  static int? parseAmount(String amount) {
    if (amount.isEmpty) return null;

    final digitsOnly = amount.replaceAll(RegExp(r'[,.]'), '');
    return int.tryParse(digitsOnly);
  }

  /// Validate amount
  /// Return null if valid, otherwise return error message
  static String? validateAmount(String value, AppLocalizations localizations) {
    if (value.isEmpty) return localizations.amountRequired;

    final amountAfterFormat = parseAmount(value);
    if (amountAfterFormat == null) return localizations.amountInvalid;
    if (amountAfterFormat <= 0) return localizations.amountMustBePositive;

    return null;
  }
}
