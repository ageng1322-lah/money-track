// lib/features/transaction/data/transaction_repository_impl.dart

import 'package:dio/dio.dart';
import '../domain/transaction_entity.dart';
import '../../../core/network/api_client.dart';

class TransactionRepository {
  final Dio _dio;
  TransactionRepository(ApiClient client) : _dio = client.dio;

  Future<PaginatedTransactions> getTransactions({
    String? type,
    int?    categoryId,
    String? from,
    String? to,
    String? search,
    String  sort    = 'date',
    String  order   = 'desc',
    int     page    = 1,
    int     perPage = 15,
  }) async {
    final res = await _dio.get('transactions', queryParameters: {
      if (type       != null) 'type':        type,
      if (categoryId != null) 'category_id': categoryId,
      if (from       != null) 'from':        from,
      if (to         != null) 'to':          to,
      if (search     != null) 'search':      search,
      'sort':     sort,
      'order':    order,
      'page':     page,
      'per_page': perPage,
    });

    final data = res.data as Map<String, dynamic>;
    return PaginatedTransactions(
      data:        (data['data'] as List).map((i) => _mapTransaction(i as Map<String, dynamic>)).toList(),
      currentPage: data['meta']['current_page'] as int,
      lastPage:    data['meta']['last_page']    as int,
      total:       data['meta']['total']        as int,
    );
  }

  Future<TransactionEntity> createTransaction({
    required String title,
    required double amount,
    required String type,
    required String date,
    int?    categoryId,
    String? note,
  }) async {
    final res = await _dio.post('transactions', data: {
      'title':       title,
      'amount':      amount,
      'type':        type,
      'date':        date,
      if (categoryId != null) 'category_id': categoryId,
      if (note       != null) 'note':        note,
    });
    return _mapTransaction(res.data['data']);
  }

  Future<TransactionEntity> updateTransaction(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('transactions/$id', data: data);
    return _mapTransaction(res.data['data']);
  }

  Future<void> deleteTransaction(int id) async {
    await _dio.delete('transactions/$id');
  }

  Future<TransactionEntity> getTransactionById(int id) async {
    final res = await _dio.get('transactions/$id');
    return _mapTransaction(res.data['data']);
  }

  TransactionEntity _mapTransaction(Map<String, dynamic> json) {
    final cat = json['category'];
    return TransactionEntity(
      id:        json['id']     as int,
      title:     json['title']  as String,
      amount:    (json['amount'] as num).toDouble(),
      type:      json['type']   as String,
      date:      DateTime.parse(json['date'] as String),
      note:      json['note']   as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      category:  cat != null ? CategoryEntity(
        id:    cat['id']    as int,
        name:  cat['name']  as String,
        icon:  cat['icon']  as String,
        color: cat['color'] as String,
        type:  cat['type']  ?? 'both',
      ) : null,
    );
  }
}
