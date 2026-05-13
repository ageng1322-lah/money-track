// lib/features/transaction/domain/transaction_entity.dart

class TransactionEntity {
  final int     id;
  final String  title;
  final double  amount;
  final String  type; // 'income' | 'expense'
  final DateTime date;
  final String? note;
  final CategoryEntity? category;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.category,
    required this.createdAt,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    final cat = json['category'];
    return TransactionEntity(
      id:        json['id']     as int,
      title:     json['title']  as String,
      amount:    (json['amount'] as num).toDouble(),
      type:      json['type']   as String,
      date:      DateTime.parse(json['date'] as String),
      note:      json['note']   as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      category:  cat != null ? CategoryEntity.fromJson(cat as Map<String, dynamic>) : null,
    );
  }

  bool get isIncome  => type == 'income';
  bool get isExpense => type == 'expense';
}

class CategoryEntity {
  final int    id;
  final String name;
  final String icon;
  final String color;
  final String type;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id:    json['id']    as int,
      name:  json['name']  as String,
      icon:  json['icon']  as String,
      color: json['color'] as String,
      type:  json['type']  ?? 'both',
    );
  }
}

class UserEntity {
  final int     id;
  final String  name;
  final String  email;
  final String? photoUrl;
  final DateTime createdAt;
  final bool     isVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    this.isVerified = false,
  });
}

class DashboardSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int    month;
  final int    year;

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.month,
    required this.year,
  });
}

class ChartDataPoint {
  final int    month;
  final String label;
  final double income;
  final double expense;

  const ChartDataPoint({
    required this.month,
    required this.label,
    required this.income,
    required this.expense,
  });
}

class PaginatedTransactions {
  final List<TransactionEntity> data;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedTransactions({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;
}
