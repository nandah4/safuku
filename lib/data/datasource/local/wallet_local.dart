import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:safuku/utils/logger.dart';
import 'package:safuku/core/utils/errors/exception.dart' as failure;

class WalletDataSource {
  final DatabaseHelper db;
  final String tableName = 'mst_wallet';

  WalletDataSource({required this.db});

  Future<int> createWallet(Wallet wallet) async {
    final database = await db.database;

    AppLogger.i(" DataSource : Wallet created successfully ${wallet.toMap()}");

    return await database.insert(tableName, wallet.toMap());
  }

  Future<int> updateWallet(Wallet wallet) async {
    final database = await db.database;
    AppLogger.i(" DataSource : Wallet updated successfully ${wallet.toMap()}");

    return await database.update(
      tableName,
      wallet.toMap(),
      where: 'id = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<int> updateSaldoWithTxn(
    Transaction txn,
    int walletId,
    String typeSymbol,
    int amount,
  ) async {
    try {
      final result = await txn.rawUpdate(
        'UPDATE $tableName SET saldo = saldo $typeSymbol ? WHERE id = ?',
        [amount, walletId],
      );

      AppLogger.i(" Local Data Source : Saldo updated successfully $result");

      return result;
    } catch (e) {
      AppLogger.e(" Local Data Source : Saldo updated failed $e");
      switch (e) {
        case DatabaseException _:
          throw failure.DatabaseException();
        default:
          throw failure.UnknownException();
      }
    }
  }

  Future<int> getSaldoWithTxn(Transaction txn, int walletId) async {
    try {
      final result = await txn.query(
        tableName,
        columns: ['saldo'],
        where: 'id = ?',
        whereArgs: [walletId],
      );

      if (result.isEmpty) {
        throw failure.DatabaseException('Wallet not found with id: $walletId');
      }

      return result.first['saldo'] as int;
    } catch (e) {
      AppLogger.e(" Local Data Source : Get saldo failed $e");
      rethrow;
    }
  }

  Future<int> getTotalSaldo() async {
    final database = await db.database;
    final result = await database.rawQuery(
      'SELECT COALESCE(SUM(saldo), 0) as total FROM $tableName',
    );
    return result.first['total'] as int;
  }

  Future<List<Wallet>> getAllWallets() async {
    final database = await db.database;
    final result = await database.query(tableName, orderBy: 'created_at DESC');

    AppLogger.i(" DataSource : Wallet load successfully $result");

    return result.map((data) => Wallet.fromMap(data)).toList();
  }

  Future<void> deleteWallet(int id) async {
    try {
      final database = await db.database;

      await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
      AppLogger.i(" DataSource : Wallet deleted successfully $id");
    } catch (e) {
      if (e is DatabaseException &&
          e.toString().contains('FOREIGN KEY constraint failed')) {
        throw failure.ConstraintException(
          'Cannot delete wallet with existing transactions',
        );
      }
      rethrow;
    }
  }
}
