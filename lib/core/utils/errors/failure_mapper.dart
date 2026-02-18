import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/core/utils/logger.dart';
import 'package:sqflite/sqflite.dart';

class FailureMapper {
  static Failure map(Object e) {
    AppLogger.e("Exception caught: $e");

    if (e is DatabaseException) {
      final message = e.toString();
      if (message.contains('UNIQUE constraint failed')) {
        if (message.contains('name')) {
          return DatabaseFailure(message: 'Data with this name already exists');
        }
        return DatabaseFailure(message: 'Data already exists');
      }
      return DatabaseFailure(message: 'Database error occurred');
    }

    return UnknownFailure(message: e.toString());
  }
}
