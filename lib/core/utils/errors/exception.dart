class DatabaseException implements Exception {
  final String? message;
  DatabaseException([this.message]);

  @override
  String toString() => message ?? 'DatabaseException';
}

class UnknownException implements Exception {
  final String? message;
  UnknownException([this.message]);

  @override
  String toString() => message ?? 'UnknownException';
}

class SaldoNotEnoughException implements Exception {
  final String? message;
  SaldoNotEnoughException([this.message]);

  @override
  String toString() => message ?? 'Insufficient balance';
}

class ConstraintException implements Exception {
  final String? message;
  ConstraintException([this.message]);

  @override
  String toString() => message ?? 'Constraint Violation';
}
