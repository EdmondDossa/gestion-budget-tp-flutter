class Expense {
  final int? id;
  final DateTime date;
  final double montant;
  final String libelle;
  final String? observation;
  final int categoryId;

  Expense({
    this.id,
    required this.date,
    required this.montant,
    required this.libelle,
    this.observation,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'montant': montant,
      'libelle': libelle,
      'observation': observation,
      'category_id': categoryId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: DateTime.parse(map['date']),
      montant: map['montant'],
      libelle: map['libelle'],
      observation: map['observation'],
      categoryId: map['category_id'],
    );
  }
}