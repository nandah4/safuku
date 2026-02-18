import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/models/transaction.dart';
import 'package:safuku/data/models/transaction_type.dart';
import 'package:safuku/core/utils/errors/exception.dart' as appexception;
import 'package:safuku/core/utils/logger.dart';
import 'package:sqflite/sqflite.dart';

class TransactionLocalDataSource {
  final DatabaseHelper db;
  final String tableName = 'trx_transaction';
  final String walletTable = 'mst_wallet';
  final String categoryTable = 'mst_category';

  TransactionLocalDataSource({required this.db});

  Future<int> createTransaction(
    Transaction txn,
    TransactionModel transaction,
  ) async {
    try {
      final result = await txn.insert(tableName, transaction.toMap());
      AppLogger.i(
        " Local Data Source : Transaction created successfully $result",
      );

      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction creation failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<int> updateTransactionWithTxn(
    Transaction txn,
    TransactionModel transaction,
  ) async {
    try {
      final result = await txn.update(
        tableName,
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
      AppLogger.i(
        "Local Data Source : Transaction updated successfully (id: ${transaction.id})",
      );
      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction update failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<List<TransactionModel>> getAllTransactions(
    int? limit,
    DateTime? date,
  ) async {
    try {
      final database = await db.database;

      // Select fields explicitly from transaction table
      final fields = [
        '$tableName.id',
        '$tableName.wallet_id',
        '$tableName.category_id',
        '$tableName.amount',
        '$tableName.type',
        '$tableName.title',
        '$tableName.description',
        '$tableName.date',
        '$tableName.created_at',
        '$tableName.updated_at',
        '$walletTable.name AS wallet_name',
        '$categoryTable.name AS category_name',
      ].join(', ');

      List<dynamic> args = [];

      String sql =
          "SELECT $fields FROM $tableName JOIN $walletTable ON $tableName.wallet_id = $walletTable.id JOIN $categoryTable ON $tableName.category_id = $categoryTable.id";

      // Filter by date if provided
      if (date != null) {
        final firstDay = DateTime(date.year, date.month, 1);
        final lastDay = DateTime(date.year, date.month + 1, 1);
        sql += " WHERE date >= ? AND date < ?";
        args.add(firstDay.toIso8601String());
        args.add(lastDay.toIso8601String());
      }

      sql += " ORDER BY $tableName.date DESC";

      if (limit != null) {
        sql += " LIMIT ?";
        args.add(limit);
      }

      final result = await database.rawQuery(sql, args);

      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction creation failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<TransactionTypeModel> getTransactionTypePerMonth(DateTime date) async {
    try {
      final database = await db.database;
      final firstDay = DateTime(date.year, date.month, 1);
      final lastDay = DateTime(date.year, date.month + 1, 1);

      String sql =
          """
      SELECT
        strftime('%Y-%m', date) as month,
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as expense
      FROM $tableName
      WHERE date >= ? AND date < ?;
      """;

      final result = await database.rawQuery(sql, [
        firstDay.toIso8601String(),
        lastDay.toIso8601String(),
      ]);

      if (result.isEmpty ||
          result.first['income'] == null ||
          result.first['expense'] == null) {
        return TransactionTypeModel(date: date, income: 0, expense: 0);
      }
      return TransactionTypeModel.fromMap(result.first);
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction type per month failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<int> deleteTransaction(int id) async {
    try {
      final database = await db.database;
      final result = await database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction deletion failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<TransactionModel> getTransactionById(int id) async {
    try {
      final database = await db.database;
      final fields = [
        '$tableName.id',
        '$tableName.wallet_id',
        '$tableName.category_id',
        '$tableName.amount',
        '$tableName.type',
        '$tableName.title',
        '$tableName.description',
        '$tableName.date',
        '$tableName.created_at',
        '$tableName.updated_at',
        '$walletTable.name AS wallet_name',
        '$categoryTable.name AS category_name',
        '$walletTable.color AS wallet_color',
      ].join(', ');

      final result = await database.rawQuery(
        "SELECT $fields FROM $tableName JOIN $walletTable ON $tableName.wallet_id = $walletTable.id JOIN $categoryTable ON $tableName.category_id = $categoryTable.id WHERE $tableName.id = ?",
        [id],
      );

      if (result.isEmpty) {
        throw appexception.DatabaseException('Transaction not found');
      }

      AppLogger.i("Local Data Source : Transaction by id fetched successfully");

      return TransactionModel.fromMap(result.first);
    } on appexception.DatabaseException catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction by id failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction by id failed ${e.toString()}",
      );
      throw appexception.UnknownException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getSpendingByCategory(
    DateTime date,
    String type,
  ) async {
    try {
      final database = await db.database;
      final firstDay = DateTime(date.year, date.month, 1);
      final lastDay = DateTime(date.year, date.month + 1, 1);

      final sql =
          """
        SELECT
          $tableName.category_id,
          $categoryTable.name AS category_name,
          SUM($tableName.amount) AS total_amount
        FROM $tableName
        JOIN $categoryTable ON $tableName.category_id = $categoryTable.id
        WHERE $tableName.date >= ? AND $tableName.date < ?
          AND $tableName.type = ?
        GROUP BY $tableName.category_id
        ORDER BY total_amount DESC
      """;

      final result = await database.rawQuery(sql, [
        firstDay.toIso8601String(),
        lastDay.toIso8601String(),
        type,
      ]);

      AppLogger.i(
        "Local Data Source : Spending by category fetched (${result.length} rows)",
      );
      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Spending by category failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getWeeklyBreakdown(DateTime date) async {
    try {
      final database = await db.database;
      final firstDay = DateTime(date.year, date.month, 1);
      final lastDay = DateTime(date.year, date.month + 1, 1);

      final sql =
          """
        SELECT
          ((CAST(strftime('%d', date) AS INTEGER) - 1) / 7 + 1) AS week_number,
          SUM(amount) AS total_amount,
          COUNT(*) AS transaction_count
        FROM $tableName
        WHERE date >= ? AND date < ?
        GROUP BY week_number
        ORDER BY week_number ASC
      """;

      final result = await database.rawQuery(sql, [
        firstDay.toIso8601String(),
        lastDay.toIso8601String(),
      ]);

      AppLogger.i(
        "Local Data Source : Weekly breakdown fetched (${result.length} rows)",
      );
      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Weekly breakdown failed ${e.toString()}",
      );
      throw appexception.DatabaseException(e.toString());
    }
  }
}
