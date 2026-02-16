import 'package:safuku/config/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/utils/errors/exception.dart' as failure;
import '../../models/category.dart';
import '../../../utils/logger.dart';

class CategoryLocalDataSource {
  late final DatabaseHelper _databaseHelper;
  final String _tableName = 'mst_category';

  CategoryLocalDataSource({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  Future<Database> get _db => _databaseHelper.database;

  Future<int> createCategory(Category category) async {
    try {
      final inserted = await (await _db).insert(_tableName, category.toMap());
      AppLogger.i("Category created successfully ${category.toMap()}");

      return inserted;
    } catch (e) {
      AppLogger.e("Category creation failed ${e.toString()}");
      switch (e) {
        case DatabaseException _:
          throw failure.DatabaseException();
        default:
          throw failure.UnknownException();
      }
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final result = await (await _db).query(
        _tableName,
        orderBy: 'created_at DESC',
      );

      AppLogger.i("Category loaded successfully $result");
      return result.map((data) => Category.fromMap(data)).toList();
    } catch (e) {
      AppLogger.e("Category loading failed ${e.toString()}");
      switch (e) {
        case DatabaseException _:
          throw failure.DatabaseException();
        default:
          throw failure.UnknownException();
      }
    }
  }
}
