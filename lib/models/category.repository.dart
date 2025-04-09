import 'dart:io';

import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'category.dart';

final class CategoryRepository implements CrudRepository<CategoryModel> {
  static const String tableName = 'categories';
  static const String identifierPrefix = 'cat';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT
    );
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  Database? _database;

  CategoryRepository() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> _getDb() async {
    _database ??= await DBHelper().database;
    return _database!;
  }

  @override
  Future<List<CategoryModel>> findAll({bool includeDeleted = false}) async {
    final db = await _getDb();

    final maps = await db.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL'
    );
    return maps.map((map) => CategoryModel.fromMap(map)).toList();
  }

  @override
  Future<List<CategoryModel>> findAllDeleted() async {
    final db = await _getDb();

    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => CategoryModel.fromMap(map)).toList();
  }

  @override
  Future<CategoryModel?> findById(int id, { bool includeDeleted = false }) async {
    final db = await _getDb();

    final maps = await db.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? CategoryModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(CategoryModel category) async {
    final now = DateTime.now().toIso8601String();

    final db = await _getDb();

    return await db.insert(
      tableName, 
      {
        ...category.toMap(),
        'created_at': now,
        'updated_at': now
      }
    );
  }

  @override
  Future<int> update(CategoryModel category) async {
    final now = DateTime.now().toIso8601String();

    final db = await _getDb();

    return await db.update(
      tableName,
      {
        ...category.toMap(), 
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [category.id]
    );
  }

  @override
  Future<int> delete(CategoryModel category) async {
    final db = await _getDb();

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> softDelete(CategoryModel category) async {
    final now = DateTime.now().toIso8601String();

    final db = await _getDb();

    return await db.update(
      tableName,
      {
        'deleted_at': now,
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> restore(CategoryModel category) async {
    final now = DateTime.now().toIso8601String();

    final db = await _getDb();

    return await db.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
