import 'package:dartz/dartz.dart';
import 'package:safuku/domain/entities/transaction_type.dart';
import '../../core/utils/errors/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, int>> createTransaction(TransactionEntity transaction);
  Future<Either<Failure, int>> updateTransaction(TransactionEntity newTransaction, TransactionEntity oldTransaction);
  Future<Either<Failure, int>> deleteTransaction(int id);
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions(int? limit, DateTime? date);
  Future<Either<Failure, TransactionTypeEntity>> getTransactionTypePerMonth(DateTime date);
  Future<Either<Failure, TransactionEntity>> getTransactionById(int id);
}
