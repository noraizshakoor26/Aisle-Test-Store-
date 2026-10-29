import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_store/core/api/auth_interceptor.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/utils/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresToken = false,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {'requiresToken': requiresToken}),
      cancelToken: cancelToken,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresToken = false,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(extra: {'requiresToken': requiresToken}),
      cancelToken: cancelToken,
    );
  }

  Failure handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'The connection timed out. Check your internet and try again.',
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          "You're offline. Check your connection and try again.",
        );
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Certificate verification failed.');
      case DioExceptionType.transformTimeout:
        return const NetworkFailure('The response took too long to read.');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkFailure(
            "You're offline. Check your connection and try again.",
          );
        }
        return UnknownFailure(
          error.message ?? 'Something went wrong. Please try again.',
        );
    }
  }

  Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    final fallbackMessage = statusCode != null && statusCode >= 500
        ? 'Our server is having trouble right now. Please try again in a moment.'
        : 'Something went wrong. Please try again.';
    String message = fallbackMessage;
    if (responseData is Map && responseData['message'] is String) {
      message = responseData['message'];
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message);
      case 401:
        return UnauthorizedFailure(message);
      case 404:
        return const ServerFailure('Not found.', statusCode: 404);
      default:
        return ServerFailure(message, statusCode: statusCode);
    }
  }
}
