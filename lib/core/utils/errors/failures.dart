class Failure {
  final String? title;
  final String? message;

  Failure({this.title, this.message});
}

// class MissMatchFailure extends Failure {
//   MissMatchFailure({String? title, String? message}): super(title: title ?? "", message: message ??);
// }

class UnknownFailure extends Failure {
  UnknownFailure({String? title, String? message})
    : super(
        title: title ?? "Error",
        message: message ?? "Something went wrong",
      );
}

class DatabaseFailure extends Failure {
  DatabaseFailure({String? title, String? message})
    : super(
        title: title ?? "Database Error",
        message: message ?? "Something went wrong",
      );
}

class EmptyFieldFailure extends Failure {
  EmptyFieldFailure({String? title, String? message})
    : super(
        title: title ?? "Empty Field",
        message: message ?? "Something went wrong",
      );
}

class SaldoNotEnoughFailure extends Failure {
  SaldoNotEnoughFailure({String? title, String? message})
    : super(
        title: title ?? "Saldo Not Enough",
        message: message ?? "The balance in the wallet is insufficient",
      );
}

class InvalidFormatFailure extends Failure {
  InvalidFormatFailure({String? title, String? message})
    : super(
        title: title ?? "Invalid Format",
        message: message ?? "Something went wrong",
      );
}

class ConstraintFailure extends Failure {
  ConstraintFailure({String? title, String? message})
    : super(
        title: title ?? "Constraint Violation",
        message: message ?? "Cannot proceed due to related data",
      );
}
