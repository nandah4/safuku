import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/models/transaction.dart';
import 'package:safuku/data/models/transaction_type.dart';
import 'package:safuku/core/utils/errors/exception.dart' as appException;
import 'package:safuku/utils/logger.dart';
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
      throw appException.DatabaseException(e.toString());
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
      AppLogger.w("""
Local Data Source : amount ${transaction.amount}
Local Data Source : name ${transaction.title}
Local Data Source : type ${transaction.type}
Local Data Source : wallet ${transaction.walletId}
Local Data Source : category ${transaction.categoryId}



""");
      return result;
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction update failed ${e.toString()}",
      );
      throw appException.DatabaseException(e.toString());
    }
  }

  Future<List<TransactionModel>> getALlTransaction(
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
      throw appException.DatabaseException(e.toString());
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
      throw appException.DatabaseException(e.toString());
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
      throw appException.DatabaseException(e.toString());
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
        throw appException.DatabaseException('Transaction not found');
      }

      AppLogger.i("Local Data Source : Transaction by id fetched successfully");

      return TransactionModel.fromMap(result.first);
    } on appException.DatabaseException catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction by id failed ${e.toString()}",
      );
      throw appException.DatabaseException(e.toString());
    } catch (e) {
      AppLogger.e(
        "Local Data Source : Transaction by id failed ${e.toString()}",
      );
      throw appException.UnknownException(e.toString());
    }
  }
}
