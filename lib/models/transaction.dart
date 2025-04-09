import '/core/persistable.model.dart';

import 'category.dart';

final class TransactionModel extends PersistableModel {
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

  TransactionModel({
    super.id,
    required this.type,
    required this.title,
    this.description,
    this.category,
    required this.amount,
    required this.currencyCode,
    required this.timestamp,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  /// Factory constructor to create a Transaction object with default values  
  factory TransactionModel.create({
    required TransactionTypeEnum type,
    required String title,
    String? description,
    CategoryModel? category,
    required double amount,
    required String currencyCode,
    required DateTime timestamp
  }) {
    return TransactionModel(
      type: type,
      title: title,
      description: description,
      category: category,
      amount: amount,
      currencyCode: currencyCode,
      timestamp: timestamp
    );
  }

  /// Factory constructor to update an existing Transaction object
  factory TransactionModel.update({
    required TransactionTypeEnum type,
    required String title,
    String? description,
    CategoryModel? category,
    required double amount,
    required String currencyCode,
    required DateTime timestamp
  }) {
    return TransactionModel(
      type: type,
      title: title,
      description: description,
      category: category,
      amount: amount,
      currencyCode: currencyCode,
      timestamp: timestamp
    );
  }

  /// Method to convert Transaction object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.id,
      'title': title,
      'description': description,
      'amount': amount,
      'currency_code': currencyCode,
      'category_id': category?.id,
      'timestamp': timestamp.toIso8601String()
    };
  }

  /// Factory constructor to create a Transaction object from a map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: TransactionTypeEnum.fromId(map['type']),
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      currencyCode: map['currency_code'],
      timestamp: DateTime.parse(map['timestamp']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      category: map['category_id'] != null
          ? CategoryModel(
              id: map['category_id'],
              name: map['category_name'],
              description: map['category_description'],
              createdAt: DateTime.parse(map['category_created_at']),
              updatedAt: DateTime.parse(map['category_updated_at']),
              deletedAt: map['category_deleted_at'] != null ? DateTime.parse(map['category_deleted_at']) : null
            )
          : null,
    );
  }
}

enum TransactionTypeEnum {
  income(100, 'transaction.type.income', 'Income'),
  expense(101, 'transaction.type.expense', 'Expense');

  final int id;
  final String code;
  final String name;

  const TransactionTypeEnum(this.id, this.code, this.name);

  static TransactionTypeEnum fromId(int id) {
    return TransactionTypeEnum.values.firstWhere((e) => e.id == id);
  }

}