class TransactionModel {
  int? id;
  int walletId;
  String? walletName;
  String? walletColor;
  int categoryId;
  String? categoryName;
  int amount;
  String type;
  String title;
  String? description;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;

  TransactionModel({
    this.id,
    required this.walletId,
    this.walletName,
    required this.categoryId,
    this.walletColor,
    this.categoryName,
    required this.amount,
    required this.type,
    required this.title,
    this.description,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionModel copyWith({
    int? id,
    int? walletId,
    String? walletName,
    String? walletColor,
    int? categoryId,
    String? categoryName,
    int? amount,
    String? type,
    String? title,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      walletColor: walletColor ?? this.walletColor,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'],
      walletId: data['wallet_id'],
      walletName: data['wallet_name'],
      walletColor: data['wallet_color'],
      categoryId: data['category_id'],
      categoryName: data['category_name'],
      amount: data['amount'],
      type: data['type'],
      title: data['title'],
      description: data['description'],
      date: DateTime.parse(data['date']),
      createdAt: DateTime.tryParse(data['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(data['updated_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'wallet_id': walletId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
