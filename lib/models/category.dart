class CategoryModel {
  /// The unique identifier for the category
  final String? id;

  /// The name of the category
  final String name;

  /// The description of the category
  final String? description;

  /// The date and time when the category was created
  final DateTime createdAt;

  /// The date and time when the category was last updated
  final DateTime? updatedAt;

  /// The date and time when the category was deleted
  final DateTime? deletedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CategoryModel.create({
    String? id,
    required String name,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    }) {
    return CategoryModel(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt
    );
  }

  factory CategoryModel.update({
    required String? id,
    required String name,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt
    }) {
    return CategoryModel(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
      deletedAt: DateTime.tryParse(map['deleted_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String()
    };
  }

}
