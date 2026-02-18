import 'package:dartz/dartz.dart';
import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/datasource/local/transaction_local.dart';
import 'package:safuku/data/datasource/local/wallet_local.dart';
import 'package:safuku/data/mapper/transaction_mapper.dart';
import 'package:safuku/data/mapper/transaction_type_mapper.dart';
import 'package:safuku/domain/entities/category_spending.dart';
import 'package:safuku/domain/entities/transaction.dart';
import 'package:safuku/domain/entities/transaction_type.dart';
import 'package:safuku/domain/entities/weekly_summary.dart';
import 'package:safuku/domain/repositories/transaction_repository.dart';
import 'package:safuku/core/utils/errors/exception.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/core/utils/errors/failure_mapper.dart';
import 'package:safuku/core/utils/logger.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _transactionLocalDataSource;
  final WalletDataSource _walletLocalDataSource;
  final DatabaseHelper _databaseHelper;

  TransactionRepositoryImpl({
    required TransactionLocalDataSource transactionLocalDataSource,
    required WalletDataSource walletLocalDataSource,
    required DatabaseHelper databaseHelper,
  }) : _transactionLocalDataSource = transactionLocalDataSource,
       _walletLocalDataSource = walletLocalDataSource,
       _databaseHelper = databaseHelper;

  @override
  Future<Either<Failure, int>> createTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final database = await _databaseHelper.database;
      int result = 0;

      await database.transaction((txn) async {
        AppLogger.i(" Repository : Transaction started");

        // Get current saldo from wallet
        final currentSaldo = await _walletLocalDataSource.getSaldoWithTxn(
          txn,
          transaction.walletId,
        );

        // Validate saldo only for expense
        if (transaction.type == 'expense' &&
            currentSaldo < transaction.amount) {
          AppLogger.i(
            " Repository : Saldo not enough (current: $currentSaldo, required: ${transaction.amount})",
          );
          throw SaldoNotEnoughException();
        }

        // Determine operation symbol
        final String typeSymbol = transaction.type == 'income' ? '+' : '-';

        // Insert transaction record
        result = await _transactionLocalDataSource.createTransaction(
          txn,
          transaction.toModel(),
        );

        // Update wallet saldo
        await _walletLocalDataSource.updateSaldoWithTxn(
          txn,
          transaction.walletId,
          typeSymbol,
          transaction.amount,
        );
      });

      AppLogger.i(
        " Repository : Transaction created successfully (id: $result)",
      );
      return Right(result);
    } on SaldoNotEnoughException {
      return Left(SaldoNotEnoughFailure());
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, int>> updateTransaction(
    TransactionEntity newTransaction,
    TransactionEntity oldTransaction,
  ) async {
    try {
      final database = await _databaseHelper.database;
      int result = 0;

      // Start transaction
      await database.transaction((txn) async {
        AppLogger.i(" Repository : Transaction update started");

        // Reverse old transaction

        final oldReverseType = oldTransaction.type.toLowerCase() == 'income'
            ? '-'
            : '+';

        await _walletLocalDataSource.updateSaldoWithTxn(
          txn,
          oldTransaction.walletId,
          oldReverseType,
          oldTransaction.amount,
        );

        // Apply now transaction
        final newTransactionType =
            newTransaction.type.toLowerCase() == 'expense' ? '-' : '+';

        if (newTransaction.type.toLowerCase() == 'expense') {
          final currentSaldo = await _walletLocalDataSource.getSaldoWithTxn(
            txn,
            newTransaction.walletId,
          );

          if (currentSaldo < newTransaction.amount) {
            throw SaldoNotEnoughException();
          }
        }

        await _walletLocalDataSource.updateSaldoWithTxn(
          txn,
          newTransaction.walletId,
          newTransactionType,
          newTransaction.amount,
        );

        // update transaction
        result = await _transactionLocalDataSource.updateTransactionWithTxn(
          txn,
          newTransaction.toModel(),
        );
      });

      AppLogger.i(
        " Repository : Transaction updated successfully (id: $result)",
      );
      return Right(result);
    } on SaldoNotEnoughException {
      AppLogger.e(
        " Repository : Transaction update failed (error: Saldo not enough)",
      );
      return Left(SaldoNotEnoughFailure());
    } catch (e) {
      AppLogger.e(" Repository : Transaction update failed (error: $e)");
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions(
    int? limit,
    DateTime? date,
  ) async {
    try {
      final result = await _transactionLocalDataSource.getAllTransactions(
        limit,
        date,
      );
      AppLogger.i(" Repository : Transaction fetched successfully");
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, TransactionTypeEntity>> getTransactionTypePerMonth(
    DateTime date,
  ) async {
    try {
      final result = await _transactionLocalDataSource
          .getTransactionTypePerMonth(date);

      AppLogger.i(
        " Repository : Transaction type per month fetched successfully",
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTransaction(int id) async {
    try {
      final database = await _databaseHelper.database;
      int result = 0;

      await database.transaction((txn) async {
        // Fetch transaction to get amount, type, and walletId
        final txnData = await txn.query(
          'trx_transaction',
          where: 'id = ?',
          whereArgs: [id],
        );

        if (txnData.isEmpty) {
          throw DatabaseException('Transaction not found');
        }

        final amount = txnData.first['amount'] as int;
        final type = txnData.first['type'] as String;
        final walletId = txnData.first['wallet_id'] as int;

        // Reverse saldo: income was added → subtract, expense was subtracted → add back
        final reverseSymbol = type == 'income' ? '-' : '+';
        await _walletLocalDataSource.updateSaldoWithTxn(
          txn,
          walletId,
          reverseSymbol,
          amount,
        );

        // Delete the transaction
        result = await txn.delete(
          'trx_transaction',
          where: 'id = ?',
          whereArgs: [id],
        );
      });

      AppLogger.i(
        " Repository : Transaction deleted successfully (id: $result)",
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> getTransactionById(int id) async {
    try {
      final result = await _transactionLocalDataSource.getTransactionById(id);
      AppLogger.i(" Repository : Transaction fetched successfully");
      return Right(result.toEntity());
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<CategorySpendingEntity>>> getSpendingByCategory(
    DateTime date,
    String type,
  ) async {
    try {
      final result = await _transactionLocalDataSource.getSpendingByCategory(
        date,
        type,
      );

      // Calculate total for percentage
      final totalAmount = result.fold<int>(
        0,
        (sum, row) => sum + ((row['total_amount'] as num?)?.toInt() ?? 0),
      );

      final entities = result.map((row) {
        final amount = (row['total_amount'] as num?)?.toInt() ?? 0;
        return CategorySpendingEntity(
          categoryId: row['category_id'] as int,
          categoryName: (row['category_name'] as String?) ?? 'Unknown',
          totalAmount: amount,
          percentage: totalAmount > 0 ? (amount / totalAmount) * 100 : 0,
        );
      }).toList();

      AppLogger.i(
        " Repository : Spending by category fetched (${entities.length} categories)",
      );
      return Right(entities);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<WeeklySummaryEntity>>> getWeeklyBreakdown(
    DateTime date,
  ) async {
    try {
      final result = await _transactionLocalDataSource.getWeeklyBreakdown(date);

      final entities = result.map((row) {
        return WeeklySummaryEntity(
          weekNumber: (row['week_number'] as num?)?.toInt() ?? 1,
          totalAmount: (row['total_amount'] as num?)?.toInt() ?? 0,
          transactionCount: (row['transaction_count'] as num?)?.toInt() ?? 0,
        );
      }).toList();

      AppLogger.i(
        " Repository : Weekly breakdown fetched (${entities.length} weeks)",
      );
      return Right(entities);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }
}
