import 'package:dartz/dartz.dart';
import 'package:safuku/domain/entities/category_spending.dart';
import 'package:safuku/domain/entities/transaction_type.dart';
import 'package:safuku/domain/entities/weekly_summary.dart';
import '../../core/utils/errors/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, int>> createTransaction(TransactionEntity transaction);
  Future<Either<Failure, int>> updateTransaction(
    TransactionEntity newTransaction,
    TransactionEntity oldTransaction,
  );
  Future<Either<Failure, int>> deleteTransaction(int id);
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions(
    int? limit,
    DateTime? date,
  );
  Future<Either<Failure, TransactionTypeEntity>> getTransactionTypePerMonth(
    DateTime date,
  );
  Future<Either<Failure, TransactionEntity>> getTransactionById(int id);
  Future<Either<Failure, List<CategorySpendingEntity>>> getSpendingByCategory(
    DateTime date,
    String type,
  );
  Future<Either<Failure, List<WeeklySummaryEntity>>> getWeeklyBreakdown(
    DateTime date,
  );
}
