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
}

class UserEntity {
  final int     id;
  final String  name;
  final String  email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
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
