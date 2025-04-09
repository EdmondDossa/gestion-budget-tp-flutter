import '/core/persistable.model.dart';

import 'category.dart';

final class BudgetModel extends PersistableModel {
  /// The periodicity of the budget, indicating how often it recurs.
  final BudgetPeriodicityEnum periodicity;

  /// The amount allocated for the budget.
  final double amount;

  /// The currency in which the budget amount is specified.
  final String currencyCode;

  /// The category associated with the budget.
  final CategoryModel category;

  /// Observations or notes related to the budget.
  final String? observation;

  /// Constructor for creating a new budget.
  BudgetModel({
    super.id,
    required this.periodicity,
    required this.amount,
    required this.currencyCode,
    this.observation,
    required this.category,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  /// Factory methods for creating a new budget or updating an existing one.
  factory BudgetModel.create({
    required BudgetPeriodicityEnum periodicity,
    required double amount,
    required String currencyCode,
    String? observation,
    required CategoryModel category
  }) {
    return BudgetModel(
      periodicity: periodicity,
      amount: amount,
      currencyCode: currencyCode,
      observation: observation,
      category: category
    );
  }

  /// Factory method for updating an existing budget.
  factory BudgetModel.update({
    required BudgetPeriodicityEnum periodicity,
    required double amount,
    required String currencyCode,
    String? observation,
    required CategoryModel category
  }) {
    return BudgetModel(
      periodicity: periodicity,
      amount: amount,
      currencyCode: currencyCode,
      observation: observation,
      category: category
    );
  }

  /// Factory method for creating a budget from a map.
  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      periodicity: BudgetPeriodicityEnum.fromId(map['periodicity']),
      amount: map['amount'],
      currencyCode: map['currency_code'],
      observation: map['observation'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      category: CategoryModel(
        id: map['category_id'],
        name: map['category_name'],
        description: map['category_description'],
        createdAt: DateTime.parse(map['category_created_at']),
        updatedAt: DateTime.parse(map['category_updated_at']),
        deletedAt: map['category_deleted_at'] != null ? DateTime.parse(map['category_deleted_at']) : null
      )
    );
  }

  /// Converts the budget to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'periodicity': periodicity.id,
      'amount': amount,
      'currency_code': currencyCode,
      'observation': observation,
      'category_id': category.id
    };
  }
}

/// Enum representing the periodicity of a budget.
enum BudgetPeriodicityEnum {
  weekly(100, 'budget.periodicity.weekly', 'Weekly'),
  monthly(101, 'budget.periodicity.monthly', 'Monthly'),
  trimesterly(102, 'budget.periodicity.trimesterly', 'Trimesterly'),
  yearly(103, 'budget.periodicity.yearly', 'Yearly');

  final int id;
  final String code;
  final String name;

  const BudgetPeriodicityEnum(this.id, this.code, this.name);

  static BudgetPeriodicityEnum fromId(int id) {
    return BudgetPeriodicityEnum.values.firstWhere((e) => e.id == id);
  }
}
