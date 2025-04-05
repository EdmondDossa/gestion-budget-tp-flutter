import 'dart:io';

import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/db/db.helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'category.dart'; 

final class CategoryRepository implements CrudRepository<Category, int> {
  Database? _database;
  static const String tableName = 'categories';

  CategoryRepository() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await DBHelper().database;
  }

  @override
  Future<List<Category>> getAll() async {
    final List<Map<String, dynamic>> maps = await _database!.query(tableName);

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  @override
  Future<Category?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> create(Category category) async {
    await _database!.insert(tableName, category.toMap());
  }

  @override
  Future<void> update(int id, Category category) async {
    await _database!.update(
      tableName,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(int id) async {
    await _database!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _database!.delete(tableName);
  }

  @override
  Future<void> save(Category category) async {
    if (category.id == null) {
      final newCategory = Category.create(
        name: category.name,
        description: category.description,
      );

      await create(newCategory);
    } else {
      final updatedCategory = Category.update(
        id: category.id!,
        name: category.name,
        description: category.description,
      );

      await update(category.id!, updatedCategory);
    }
  }
}
