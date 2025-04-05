class Category {
  final int? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.create({required String name, String? description}) {
    final now = DateTime.now();

    return Category(
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Category.update({required int id, required String name, String? description}) {
    final now = DateTime.now();

    return Category(
      id: id,
      name: name,
      description: description,
      updatedAt: now,
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Category {id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt }';
  }
}
