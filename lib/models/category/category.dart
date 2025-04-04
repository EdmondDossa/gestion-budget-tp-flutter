class Category {
  final int? id;
  final String nom;

  Category({
    this.id,
    required this.nom,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      nom: map['nom'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, nom: $nom}';
  }

}