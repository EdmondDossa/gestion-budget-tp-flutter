import 'dart:io';
import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/utils/nanoid.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'income.dart'; 

final class IncomeRepository implements CrudRepository<IncomeModel> {
  static const String tableName = 'incomes';
  static const String identifierPrefix = 'inc';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      amount REAL NOT NULL,
      label TEXT NOT NULL,
      observation TEXT,
      date TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT
    );
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  static Database? _database;

  IncomeRepository() {
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
  Future<List<IncomeModel>> findAll({bool includeDeleted = false}) async {
    if (_database == null) {
      await _initializeDatabase();
    }
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => IncomeModel.fromMap(map)).toList();
  }

  @override
  Future<List<IncomeModel>> findAllDeleted() async {
    final maps = await _database!.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => IncomeModel.fromMap(map)).toList();
  }

  @override
  Future<IncomeModel?> findById(
    String id, {
    bool includeDeleted = false,
  }) async {
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? IncomeModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(IncomeModel income) async {
    if (_database == null) {
      await _initializeDatabase();
    }
    return await _database!.insert(tableName, {
      ...income.toMap(),
      'id': NanoidUtils.generate(prefix: identifierPrefix),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<int> update(IncomeModel income) async {
    return await _database!.update(
      tableName,
      {...income.toMap(), 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  @override
  Future<int> delete(IncomeModel income) async {
    return await _database!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  @override
  Future<int> softDelete(IncomeModel income) async {
    final now = DateTime.now().toIso8601String();
    return await _database!.update(
      tableName,
      {'deleted_at': now, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  @override
  Future<int> restore(IncomeModel income) async {
    return await _database!.update(
      tableName,
      {'deleted_at': null, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }
}
