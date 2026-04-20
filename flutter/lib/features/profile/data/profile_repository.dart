// lib/features/profile/data/profile_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

import '../../transaction/domain/transaction_entity.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(ApiClient client)
      : _dio     = client.dio;

  Future<UserEntity> getProfile() async {
    final res = await _dio.get('profile');
    return _mapUser(res.data['data']);
  }

  Future<UserEntity> updateProfile({String? name, String? email}) async {
    final res = await _dio.put('profile', data: {
      if (name  != null) 'name':  name,
      if (email != null) 'email': email,
    });
    return _mapUser(res.data['data']);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.put('profile/password', data: {
      'current_password':      currentPassword,
      'password':              newPassword,
      'password_confirmation': newPassword,
    });
  }

  Future<String> updatePhoto(String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath, filename: 'photo.jpg'),
    });
    final res = await _dio.post('profile/photo', data: formData);
    return res.data['photo_url'] as String;
  }

  Future<void> deletePhoto() async {
    await _dio.delete('profile/photo');
  }

  UserEntity _mapUser(Map<String, dynamic> json) => UserEntity(
    id:        json['id']         as int,
    name:      json['name']       as String,
    email:     json['email']      as String,
    photoUrl:  json['photo_url']  as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
