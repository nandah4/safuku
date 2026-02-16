class TransactionTypeModel {
  final DateTime date;
  final int income;
  final int expense;

  TransactionTypeModel({
    required this.date,
    required this.income,
    required this.expense,
  });

  factory TransactionTypeModel.fromMap(Map<String, dynamic> json) {
    return TransactionTypeModel(
      date: DateTime.tryParse(json['month']) ?? DateTime.now(),
      income: json['income'] as int,
      expense: json['expense'] as int,
    );
  }
}
