import 'package:safuku/data/models/transaction_type.dart';
import 'package:safuku/domain/entities/transaction_type.dart';

extension TransactionTypeModelToEntity on TransactionTypeModel {
  TransactionTypeEntity toEntity() {
    return TransactionTypeEntity(date: date, income: income, expense: expense);
  }
}
