// lib/features/dashboard/data/dashboard_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../transaction/domain/transaction_entity.dart';

class DashboardRepository {
  final Dio _dio;
  DashboardRepository(ApiClient client) : _dio = client.dio;

  Future<({
    DashboardSummary summary,
    List<ChartDataPoint> chartData,
    List<TransactionEntity> recent,
  })> getDashboard({int? month, int? year}) async {
    final res = await _dio.get('/dashboard', queryParameters: {
      if (month != null) 'month': month,
      if (year  != null) 'year':  year,
    });

    final data    = res.data as Map<String, dynamic>;
    final sum     = data['summary']    as Map<String, dynamic>;
    final chart   = (data['chart_data'] as List).cast<Map<String, dynamic>>();
    final recentRaw = (data['recent'] as List).cast<Map<String, dynamic>>();

    return (
      summary: DashboardSummary(
        totalIncome:  (sum['total_income']  as num).toDouble(),
        totalExpense: (sum['total_expense'] as num).toDouble(),
        balance:      (sum['balance']       as num).toDouble(),
        month:        sum['month'] as int,
        year:         sum['year']  as int,
      ),
      chartData: chart.map((d) => ChartDataPoint(
        month:   d['month']   as int,
        label:   d['label']   as String,
        income:  (d['income']  as num).toDouble(),
        expense: (d['expense'] as num).toDouble(),
      )).toList(),
      recent: recentRaw.map(_mapTx).toList(),
    );
  }

  TransactionEntity _mapTx(Map<String, dynamic> json) {
    final cat = json['category'] as Map<String, dynamic>?;
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
        type:  'both',
      ) : null,
    );
  }
}
