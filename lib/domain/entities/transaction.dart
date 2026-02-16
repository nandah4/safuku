class TransactionEntity {
  final int? id;
  final int walletId;
  final String? walletName;
  final String? walletColor;
  final int categoryId;
  final String? categoryName;
  final int amount;
  final String type;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TransactionEntity({
    this.id,
    required this.walletId,
    this.walletColor,
    this.walletName,
    required this.categoryId,
    this.categoryName,
    required this.amount,
    required this.type,
    required this.title,
    this.description,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });
}
