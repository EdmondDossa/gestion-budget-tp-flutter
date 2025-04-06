import '../currency/currency.model.dart';

final class BudgetModel {
  /// The unique identifier for the budget. 
  final String? id;

  /// The name of the budget.
  final String name;

  /// A description of the budget.
  final String? description;

  /// The periodicity of the budget, indicating how often it recurs.
  final BudgetPeriodicityEnum periodicity;

  /// The amount allocated for the budget.
  final double amount;

  /// The currency of the budget amount.
  final CurrencyModel currency;

  /// The date and time when the budget was created.
  final DateTime createdAt;

  /// The date and time when the budget was last updated.
  final DateTime? updatedAt;

  /// The date and time when the budget was deleted.
  final DateTime? deletedAt;

  /// Constructor for creating a new budget.
  BudgetModel({
    this.id,
    required this.name,
    this.description,
    required this.periodicity,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Factory methods for creating a new budget or updating an existing one.
  factory BudgetModel.create({
    String? id,
    required String name,
    String? description,
    required BudgetPeriodicityEnum periodicity,
    required double amount,
    required CurrencyModel currency, 
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {    
    return BudgetModel(
      id: id,
      name: name,
      description: description,
      periodicity: periodicity,
      amount: amount,
      currency: currency,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Factory method for updating an existing budget.
  factory BudgetModel.update({
    required String id,
    required String name,
    String? description,
    required BudgetPeriodicityEnum periodicity,
    required double amount,
    required CurrencyModel currency,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {    
    return BudgetModel(
      id: id,
      name: name,
      description: description,
      periodicity: periodicity,
      amount: amount,
      currency: currency,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Factory method for creating a budget from a map.
  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      periodicity: BudgetPeriodicityEnum.fromCode(map['periodicity']),
      amount: map['amount'],
      currency: CurrencyModel.fromMap(map['currency']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
      deletedAt: DateTime.tryParse(map['deleted_at']),
    );
  }

  /// Converts the budget to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'periodicity': periodicity.code,
      'amount': amount,
      'currency': currency.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

}

/// Enum representing the periodicity of a budget.
enum BudgetPeriodicityEnum {
  weekly(100, 'weekly', 'Weekly'),
  monthly(101, 'monthly', 'Monthly'),
  trimesterly(102, 'trimesterly', 'Trimesterly'),
  yearly(103, 'yearly', 'Yearly');

  final int id;
  final String code;
  final String name;

  const BudgetPeriodicityEnum(this.id, this.code, this.name);

  static BudgetPeriodicityEnum fromCode(String code) {
    return BudgetPeriodicityEnum.values.firstWhere((e) => e.code == code);
  }

}
