// lib/features/category/data/category_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../transaction/domain/transaction_entity.dart';

class CategoryRepository {
  final Dio _dio;
  CategoryRepository(ApiClient client) : _dio = client.dio;

  Future<List<CategoryEntity>> getCategories({String? type}) async {
    final res = await _dio.get('/categories', queryParameters: {
      if (type != null) 'type': type,
    });
    return (res.data['data'] as List).map((c) => CategoryEntity(
      id:    c['id']    as int,
      name:  c['name']  as String,
      icon:  c['icon']  as String,
      color: c['color'] as String,
      type:  c['type']  as String,
    )).toList();
  }

  Future<CategoryEntity> createCategory({
    required String name,
    required String icon,
    required String type,
    String color = '#1D9E75',
  }) async {
    final res = await _dio.post('/categories', data: {
      'name':  name,
      'icon':  icon,
      'type':  type,
      'color': color,
    });
    final c = res.data['data'];
    return CategoryEntity(
      id: c['id'], name: c['name'], icon: c['icon'],
      color: c['color'], type: c['type'],
    );
  }

  Future<void> deleteCategory(int id) async {
    await _dio.delete('/categories/$id');
  }
}
