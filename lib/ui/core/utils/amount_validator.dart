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
  static String? validateAmount(String value) {
    if (value.isEmpty) return "Amount is required";

    final amountAfterFormat = parseAmount(value);
    if (amountAfterFormat == null) return "Invalid amount";
    if (amountAfterFormat <= 0) return "Amount must be greater than 0";

    return null;
  }
}
