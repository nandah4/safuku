import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


/// Test-friendly version of DatabaseHelper that allows injection
class TestDatabaseHelper {
  Database? _database;
  final String dbName;

  TestDatabaseHelper({this.dbName = 'test_safuku.db'});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Use in-memory database for testing
    _database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDB),
    );
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

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
        name $textType,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // transactions table
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
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    await close();
  }
}

void main() {
  // Initialize FFI for desktop testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late TestDatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = TestDatabaseHelper();
  });

  tearDown(() async {
    await dbHelper.deleteDatabase();
  });

  group('DatabaseHelper Initialization', () {
    test('should create database successfully', () async {
      final db = await dbHelper.database;
      expect(db, isNotNull);
      expect(db.isOpen, isTrue);
    });

    test('should return same database instance on multiple calls', () async {
      final db1 = await dbHelper.database;
      final db2 = await dbHelper.database;
      expect(identical(db1, db2), isTrue);
    });
  });

  group('mst_wallet table', () {
    test('should create mst_wallet table with correct schema', () async {
      final db = await dbHelper.database;

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='mst_wallet'",
      );

      expect(tables.length, 1);
      expect(tables.first['name'], 'mst_wallet');
    });

    test('should insert wallet successfully', () async {
      final db = await dbHelper.database;

      final now = DateTime.now().toIso8601String();
      final id = await db.insert('mst_wallet', {
        'name': 'Main Wallet',
        'saldo': 100000,
        'color': '#FF5733',
        'created_at': now,
        'updated_at': now,
      });

      expect(id, greaterThan(0));
    });

    test('should read wallet successfully', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      await db.insert('mst_wallet', {
        'name': 'Test Wallet',
        'saldo': 50000,
        'color': '#00FF00',
        'created_at': now,
        'updated_at': now,
      });

      final wallets = await db.query('mst_wallet');

      expect(wallets.length, 1);
      expect(wallets.first['name'], 'Test Wallet');
      expect(wallets.first['saldo'], 50000);
    });

    test('should update wallet successfully', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      final id = await db.insert('mst_wallet', {
        'name': 'Original Name',
        'saldo': 10000,
        'color': '#000000',
        'created_at': now,
        'updated_at': now,
      });

      final updatedRows = await db.update(
        'mst_wallet',
        {'name': 'Updated Name', 'saldo': 20000, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(updatedRows, 1);

      final wallet = await db.query(
        'mst_wallet',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(wallet.first['name'], 'Updated Name');
      expect(wallet.first['saldo'], 20000);
    });

    test('should delete wallet successfully', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      final id = await db.insert('mst_wallet', {
        'name': 'To Delete',
        'saldo': 5000,
        'color': '#FFFFFF',
        'created_at': now,
        'updated_at': now,
      });

      final deletedRows = await db.delete(
        'mst_wallet',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(deletedRows, 1);

      final wallets = await db.query(
        'mst_wallet',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(wallets, isEmpty);
    });
  });

  group('mst_category table', () {
    test('should create mst_category table with correct schema', () async {
      final db = await dbHelper.database;

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='mst_category'",
      );

      expect(tables.length, 1);
    });

    test('should insert category successfully', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      final id = await db.insert('mst_category', {
        'name': 'Food',
        'created_at': now,
        'updated_at': now,
      });

      expect(id, greaterThan(0));
    });

    test('should query all categories', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      await db.insert('mst_category', {
        'name': 'Food',
        'created_at': now,
        'updated_at': now,
      });
      await db.insert('mst_category', {
        'name': 'Transport',
        'created_at': now,
        'updated_at': now,
      });

      final categories = await db.query('mst_category');

      expect(categories.length, 2);
    });
  });

  group('trx_transaction table', () {
    test('should create trx_transaction table with correct schema', () async {
      final db = await dbHelper.database;

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='trx_transaction'",
      );

      expect(tables.length, 1);
    });

    test('should insert transaction with valid foreign keys', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      // First insert wallet and category
      final walletId = await db.insert('mst_wallet', {
        'name': 'Main Wallet',
        'saldo': 100000,
        'color': '#FF5733',
        'created_at': now,
        'updated_at': now,
      });

      final categoryId = await db.insert('mst_category', {
        'name': 'Food',
        'created_at': now,
        'updated_at': now,
      });

      // Insert transaction
      final transactionId = await db.insert('trx_transaction', {
        'wallet_id': walletId,
        'category_id': categoryId,
        'amount': 25000,
        'type': 'expense',
        'title': 'Lunch',
        'description': 'Lunch at restaurant',
        'date': now,
        'created_at': now,
        'updated_at': now,
      });

      expect(transactionId, greaterThan(0));
    });

    test('should query transactions with wallet join', () async {
      final db = await dbHelper.database;
      final now = DateTime.now().toIso8601String();

      // Setup data
      final walletId = await db.insert('mst_wallet', {
        'name': 'Main Wallet',
        'saldo': 100000,
        'color': '#FF5733',
        'created_at': now,
        'updated_at': now,
      });

      final categoryId = await db.insert('mst_category', {
        'name': 'Food',
        'created_at': now,
        'updated_at': now,
      });

      await db.insert('trx_transaction', {
        'wallet_id': walletId,
        'category_id': categoryId,
        'amount': 25000,
        'type': 'expense',
        'title': 'Lunch',
        'description': null,
        'date': now,
        'created_at': now,
        'updated_at': now,
      });

      // Query with join
      final results = await db.rawQuery('''
        SELECT t.*, w.name as wallet_name, c.name as category_name
        FROM trx_transaction t
        INNER JOIN mst_wallet w ON t.wallet_id = w.id
        INNER JOIN mst_category c ON t.category_id = c.id
      ''');

      expect(results.length, 1);
      expect(results.first['wallet_name'], 'Main Wallet');
      expect(results.first['category_name'], 'Food');
      expect(results.first['amount'], 25000);
    });
  });

  group('Database close', () {
    test('should close database successfully', () async {
      final db = await dbHelper.database;
      expect(db.isOpen, isTrue);

      await dbHelper.close();

      // After close, getting database should create new instance
      final newDb = await dbHelper.database;
      expect(newDb.isOpen, isTrue);
    });
  });
}
