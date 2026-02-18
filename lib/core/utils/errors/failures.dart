class Failure {
  final String? title;
  final String? message;

  Failure({this.title, this.message});
}

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

class SaldoNotEnoughFailure extends Failure {
  SaldoNotEnoughFailure({String? title, String? message})
    : super(
        title: title ?? "Saldo Not Enough",
        message: message ?? "The balance in the wallet is insufficient",
      );
}

class FileSystemFailure extends Failure {
  FileSystemFailure({String? title, String? message})
    : super(
        title: title ?? "File System Error",
        message: message ?? "Something went wrong",
      );
}

class ShareDismissedException extends Failure {
  ShareDismissedException({String? title, String? message})
    : super(
        title: title ?? "Share Dismissed",
        message: message ?? "Something went wrong",
      );
}
