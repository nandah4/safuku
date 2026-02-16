import 'package:safuku/data/models/transaction.dart';
import 'package:safuku/domain/entities/transaction.dart';

extension TransactionEntityToModel on TransactionEntity {
  TransactionModel toModel() {
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      type: type,
      description: description,
      categoryId: categoryId,
      walletId: walletId,
      date: date,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension TransactionModelToEntity on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      type: type,
      description: description,
      categoryId: categoryId,
      walletId: walletId,
      date: date,
      walletName: walletName,
      walletColor: walletColor,
      categoryName: categoryName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
