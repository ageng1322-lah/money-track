// lib/features/auth/data/auth_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../transaction/domain/transaction_entity.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(ApiClient client)
      : _dio     = client.dio,
        _storage = const FlutterSecureStorage();

  Future<({String token, UserEntity user})> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('login', data: {
      'email':    email,
      'password': password,
    });
    final token = res.data['token'] as String;
    await _storage.write(key: AppConstants.tokenKey, value: token);
    return (token: token, user: _mapUser(res.data['user']));
  }

  Future<({String token, UserEntity user})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await _dio.post('register', data: {
      'name':                  name,
      'email':                 email,
      'password':              password,
      'password_confirmation': passwordConfirmation,
    });
    final token = res.data['token'] as String;
    await _storage.write(key: AppConstants.tokenKey, value: token);
    return (token: token, user: _mapUser(res.data['user']));
  }

  Future<void> logout() async {
    try {
      await _dio.post('logout');
    } finally {
      await _storage.delete(key: AppConstants.tokenKey);
    }
  }

  Future<UserEntity> getMe() async {
    final res = await _dio.get('me');
    return _mapUser(res.data);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  UserEntity _mapUser(Map<String, dynamic> json) => UserEntity(
    id:        json['id']         as int,
    name:      json['name']       as String,
    email:     json['email']      as String,
    photoUrl:  json['photo_url']  as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
