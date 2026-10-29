import 'package:dio/dio.dart';
import 'package:test_store/core/services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresToken = options.extra['requiresToken'] ?? false;
    if (requiresToken) {
      final String? token = await SecureStorageService().token;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }
}
