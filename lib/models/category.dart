import '/core/persistable.model.dart';

class CategoryModel extends PersistableModel {
  /// The name of the category
  final String name;

  /// The description of the category
  final String? description;

  CategoryModel({
    super.id,
    required this.name,
    this.description,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory CategoryModel.create({
    required String name,
    String? description
  }) {
    return CategoryModel(
      name: name,
      description: description
    );
  }

  factory CategoryModel.update({
    required String name,
    String? description
  }) {
    return CategoryModel(
      name: name,
      description: description
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description
    };
  }
}
