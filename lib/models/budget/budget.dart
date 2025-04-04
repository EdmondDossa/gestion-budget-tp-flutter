class Budget {
  final String id;
  final String name;
  final double amount;
  final DateTime createdAt;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
  });

  // Convert a Budget object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a Budget object from a Map
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}