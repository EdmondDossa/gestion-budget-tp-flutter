import 'dart:io';

import 'package:budgetti/db/crud.dart';
import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/models/category.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CategoryRepository implements CrudInterface<Category> {
  Database? _database;

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
    final List<Map<String, dynamic>> maps = await _database!.query('categories');

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  @override
  Future<Category?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'categories',
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
    await _database!.insert('categories', category.toMap());
  }

  @override
  Future<void> update(String id, Category category) async {
    await _database!.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database!.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<void> deleteAll() async {
    await _database!.delete('categories');
  }
}