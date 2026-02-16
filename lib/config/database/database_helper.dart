import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../utils/logger.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('safuku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, filePath);

    _database = await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );

    return _database!;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print('Upgrading database from version $oldVersion to $newVersion');
    }

    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    switch (newVersion) {
      case 1:
        break;
      case 2:
        AppLogger.i('Upgrading database from version 1 to 2');

        await db.execute('PRAGMA foreign_keys = OFF');

        // Deduplication logic for mst_category
        final duplicates = await db.rawQuery(
          'SELECT name, COUNT(*) AS c FROM mst_category GROUP BY name HAVING c > 1',
        );

        for (var row in duplicates) {
          final name = row['name'] as String;

          // Get all IDs for this duplicate name
          final idsResult = await db.query(
            'mst_category',
            columns: ['id'],
            where: 'name = ?',
            whereArgs: [name],
            orderBy: 'id ASC',
          );

          final ids = idsResult.map((e) => e['id'] as int).toList();

          if (ids.length > 1) {
            final duplicateIds = ids.sublist(1);
            final idsString = duplicateIds.join(',');

            // Delete duplicates
            await db.execute('''
              DELETE FROM mst_category 
              WHERE id IN ($idsString)
            ''');
            AppLogger.i('Deleted duplicates for category: $name');
          }

          AppLogger.i('Migration finished for category');
        }

        // Crete mst_category (+ unique constraint)
        await db.execute('''
        CREATE TABLE mst_category_new (
        id $idType,
        name $textType UNIQUE,
        created_at $textType,
        updated_at $textType
        )
        ''');

        // Copy data
        await db.execute(
          'INSERT INTO mst_category_new (id, name, created_at, updated_at) SELECT id, name, created_at, updated_at FROM mst_category',
        );

        // Drop old table
        await db.execute('DROP TABLE mst_category');

        // Rename new table
        await db.execute('ALTER TABLE mst_category_new RENAME TO mst_category');

        await db.execute('PRAGMA foreign_keys = ON');

        break;
      case 3:
        AppLogger.i('Upgrading database from version 2 to 3');
        await db.execute('PRAGMA foreign_keys = OFF');

        // Create trx_transaction to change fk wallet to restrict
        await db.execute('''
        CREATE TABLE trx_transaction_new (
        id $idType,
        wallet_id $integerType,
        category_id $integerType,
        amount $integerType,
        type $textType,
        title $textType,
        description TEXT,
        date $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (wallet_id) REFERENCES mst_wallet(id) ON DELETE RESTRICT,
        FOREIGN KEY (category_id) REFERENCES mst_category(id) ON DELETE RESTRICT
        )
''');
        // Copy data
        await db.execute(
          'INSERT INTO trx_transaction_new (id, wallet_id, category_id, amount, type, title, description, date, created_at, updated_at) SELECT id, wallet_id, category_id, amount, type, title, description, date, created_at, updated_at FROM trx_transaction',
        );

        // Drop old table
        await db.execute('DROP TABLE trx_transaction');

        // Rename new table
        await db.execute(
          'ALTER TABLE trx_transaction_new RENAME TO trx_transaction',
        );

        // Enable foreign keys
        await db.execute('PRAGMA foreign_keys = ON');

        AppLogger.i('Migration finished for transaction');
        break;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    try {
      // master table for wallet
      await db.execute('''
    CREATE TABLE mst_wallet (
    id $idType,
    name $textType,
    saldo $integerType,
    color $textType,
    created_at $textType,
    updated_at $textType
    )
''');

      // master table for category
      await db.execute('''
    CREATE TABLE mst_category (
    id $idType,
    name $textType UNIQUE,
    created_at $textType,
    updated_at $textType
    )
''');

      // transactions table for transaction
      await db.execute('''
    CREATE TABLE trx_transaction (
    id $idType,
    wallet_id $integerType,
    category_id $integerType,
    amount $integerType,
    type $textType,
    title $textType,
    description TEXT,
    date $textType,
    created_at $textType,
    updated_at $textType,
    FOREIGN KEY (wallet_id) REFERENCES mst_wallet(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES mst_category(id) ON DELETE RESTRICT
    )
''');

      if (kDebugMode) {
        print('Database created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating database: $e');
      }
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    print('Closing database');
    await db.close();
  }
}
