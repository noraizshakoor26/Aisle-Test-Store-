import 'package:test_store/core/api/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;
  final bool isSuccess;

  const Result._({this.data, this.failure, required this.isSuccess});

  factory Result.success([T? data]) =>
      Result._(data: data as T, isSuccess: true);
  factory Result.failure(Failure failure) =>
      Result._(failure: failure, isSuccess: false);

  bool get isFailure => !isSuccess;

  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure!);
    }
  }
}
