import 'package:safuku/config/database/database_helper.dart';
import 'package:safuku/data/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:safuku/core/utils/logger.dart';
import 'package:safuku/core/utils/errors/exception.dart' as exc;

class WalletDataSource {
  final DatabaseHelper db;
  final String tableName = 'mst_wallet';

  WalletDataSource({required this.db});

  Future<int> createWallet(Wallet wallet) async {
    try {
      final database = await db.database;
      final result = await database.insert(tableName, wallet.toMap());
      AppLogger.i(
        " DataSource : Wallet created successfully ${wallet.toMap()}",
      );
      return result;
    } catch (e) {
      AppLogger.e(" DataSource : Wallet creation failed $e");
      throw exc.DatabaseException(e.toString());
    }
  }

  Future<int> updateWallet(Wallet wallet) async {
    try {
      final database = await db.database;
      final result = await database.update(
        tableName,
        wallet.toMap(),
        where: 'id = ?',
        whereArgs: [wallet.id],
      );
      AppLogger.i(
        " DataSource : Wallet updated successfully ${wallet.toMap()}",
      );
      return result;
    } catch (e) {
      AppLogger.e(" DataSource : Wallet update failed $e");
      throw exc.DatabaseException(e.toString());
    }
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
          throw exc.DatabaseException();
        default:
          throw exc.UnknownException();
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
        throw exc.DatabaseException('Wallet not found with id: $walletId');
      }

      return result.first['saldo'] as int;
    } catch (e) {
      AppLogger.e(" Local Data Source : Get saldo failed $e");
      rethrow;
    }
  }

  Future<int> getTotalSaldo() async {
    try {
      final database = await db.database;
      final result = await database.rawQuery(
        'SELECT COALESCE(SUM(saldo), 0) as total FROM $tableName',
      );
      return result.first['total'] as int;
    } catch (e) {
      AppLogger.e(" DataSource : Get total saldo failed $e");
      throw exc.DatabaseException(e.toString());
    }
  }

  Future<List<Wallet>> getAllWallets() async {
    try {
      final database = await db.database;
      final result = await database.query(
        tableName,
        orderBy: 'created_at DESC',
      );
      AppLogger.i(" DataSource : Wallet load successfully $result");
      return result.map((data) => Wallet.fromMap(data)).toList();
    } catch (e) {
      AppLogger.e(" DataSource : Wallet load failed $e");
      throw exc.DatabaseException(e.toString());
    }
  }

  Future<void> deleteWallet(int id) async {
    try {
      final database = await db.database;

      await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
      AppLogger.i(" DataSource : Wallet deleted successfully $id");
    } catch (e) {
      if (e is DatabaseException &&
          e.toString().contains('FOREIGN KEY constraint failed')) {
        throw exc.ConstraintException(
          'Cannot delete wallet with existing transactions',
        );
      }
      rethrow;
    }
  }
}
