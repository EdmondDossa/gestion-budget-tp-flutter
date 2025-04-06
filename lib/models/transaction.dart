import 'category.dart';

final class TransactionModel {
  /// Unique transaction ID
  final String? id;

  /// Transaction type: income, expense, transfer
  final TransactionTypeEnum type;

  /// Short title or label for the transaction
  final String title;

  /// Optional detailed description or note
  final String? description;

  /// Optional category
  final CategoryModel? category;

  /// Amount of the transaction
  final double amount;

  /// Currency used
  final String currencyCode;

  /// Date and time of the transaction
  final DateTime timestamp;

  /// The date and time when the budget was created.
  final DateTime createdAt;

  /// The date and time when the budget was last updated.
  final DateTime? updatedAt;

  /// The date and time when the budget was deleted.
  final DateTime? deletedAt;

  TransactionModel({
    this.id,
    required this.type,
    required this.title,
    this.description,
    this.category,
    required this.amount,
    required this.currencyCode,
    required this.timestamp,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Factory constructor to create a Transaction object with default values  
  factory TransactionModel.create({
    String? id,
    required TransactionTypeEnum type,
    required String title,
    String? description,
    CategoryModel? category,
    required double amount,
    required String currencyCode,
    required DateTime timestamp,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt
  }) {
    return TransactionModel(
      id: id,
      type: type,
      title: title,
      description: description,
      category: category,
      amount: amount,
      currencyCode: currencyCode,
      timestamp: timestamp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt
    );
  }

  /// Factory constructor to update an existing Transaction object
  factory TransactionModel.update({
    required String? id,
    required TransactionTypeEnum type,
    required String title,
    String? description,
    CategoryModel? category,
    required double amount,
    required String currencyCode,
    required DateTime timestamp,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt
  }) {
    return TransactionModel(
      id: id,
      type: type,
      title: title,
      description: description,
      category: category,
      amount: amount,
      currencyCode: currencyCode,
      timestamp: timestamp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt
    );
  }

  /// Factory constructor to create a Transaction object from a map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: TransactionTypeEnum.fromId(map['type']),
      title: map['title'],
      description: map['description'],
      category: CategoryModel.fromMap(map['category']),
      amount: map['amount'],
      currencyCode: map['currency_code'],
      timestamp: DateTime.parse(map['timestamp']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
      deletedAt: DateTime.tryParse(map['deleted_at']),
    );
  }

  /// Method to convert Transaction object to MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.id,
      'title': title,
      'description': description,
      'amount': amount,
      'currency_code': currencyCode,
      'category': category?.toMap(),
      'timestamp': timestamp.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

}

enum TransactionTypeEnum {
  income(100, 'income', 'Income'),
  expense(101, 'expense', 'Expense');

  final int id;
  final String code;
  final String name;

  const TransactionTypeEnum(this.id, this.code, this.name);

  static TransactionTypeEnum fromId(int id) {
    return TransactionTypeEnum.values.firstWhere((e) => e.id == id);
  }

}