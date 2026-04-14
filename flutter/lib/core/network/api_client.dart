// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl:        AppConstants.baseUrl,
      connectTimeout: Duration(seconds: AppConstants.connectTimeout),
      receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
      headers: {
        'Accept':       'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      _ErrorInterceptor(),
      LogInterceptor(
        requestBody:  true,
        responseBody: true,
      ),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.delete(key: AppConstants.tokenKey);
      // Trigger navigation to login — handled by router redirect
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Koneksi timeout. Periksa koneksi internet Anda.';
        break;
      case DioExceptionType.badResponse:
        final body = err.response?.data;
        message = (body is Map ? body['message'] : null) ??
            'Terjadi kesalahan pada server.';
        break;
      case DioExceptionType.connectionError:
        message = 'Tidak dapat terhubung ke server.';
        break;
      default:
        message = 'Terjadi kesalahan. Silakan coba lagi.';
    }

    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error:          message,
      type:           err.type,
      response:       err.response,
    ));
  }
}
