class IncomeModel {
  final String? id;
  final double amount;
  final String label;
  final String? observation;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  IncomeModel({
    this.id,
    required this.amount,
    required this.label,
    this.observation,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory IncomeModel.create({
    String? id,
    required double amount,
    required String label,
    String? observation,
    required DateTime date,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return IncomeModel(
      id: id,
      amount: amount,
      label: label,
      observation: observation,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  factory IncomeModel.update({
    required String id,
    required double amount,
    required String label,
    String? observation,
    required DateTime date,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return IncomeModel(
      id: id,
      amount: amount,
      label: label,
      observation: observation,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'],
      amount: map['amount'],
      label: map['label'],
      observation: map['observation'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? ''),
      deletedAt: DateTime.tryParse(map['deleted_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'label': label,
      'observation': observation,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
