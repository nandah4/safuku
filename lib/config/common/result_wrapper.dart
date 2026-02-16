class Result<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  Result({this.data, this.message, required this.isSuccess});

  factory Result.success(T data) {
    return Result(data: data, isSuccess: true);
  }

  factory Result.error(String message) {
    return Result(message: message, isSuccess: false);
  }
}
