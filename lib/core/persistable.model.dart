abstract class PersistableModel {
  /// The unique identifier for the model instance.
  final int? id;

  /// The date and time when the model instance was created.
  final DateTime? createdAt;

  /// The date and time when the model instance was last updated.
  final DateTime? updatedAt;

  /// The date and time when the model instance was deleted.
  final DateTime? deletedAt;

  PersistableModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

}