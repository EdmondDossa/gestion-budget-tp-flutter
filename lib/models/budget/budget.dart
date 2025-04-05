import 'budget_periodicity.enum.dart';

class Budget {
  final int? id;
  final String name;
  final String? description;
  final BudgetPeriodicityEnum periodicity;
  final double amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Budget({
    this.id,
    required this.name,
    this.description,
    required this.periodicity,
    required this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory Budget.create({
    required String name,
    String? description,
    required BudgetPeriodicityEnum periodicity,
    required double amount,
  }) {
    final now = DateTime.now();
    
    return Budget(
      name: name,
      description: description,
      periodicity: periodicity,
      amount: amount,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Budget.update({
    required int id,
    required String name,
    String? description,
    required BudgetPeriodicityEnum periodicity,
    required double amount,
  }) {
    final now = DateTime.now();
    
    return Budget(
      id: id,
      name: name,
      description: description,
      periodicity: periodicity,
      amount: amount,
      updatedAt: now
    );
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      periodicity: BudgetPeriodicityEnum.fromCode(map['periodicity']),
      amount: map['amount'],
      createdAt: DateTime.tryParse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'periodicity': periodicity.code,
      'amount': amount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Budget{id: $id, name: $name, periodicity: ${periodicity.name}, amount: $amount, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
