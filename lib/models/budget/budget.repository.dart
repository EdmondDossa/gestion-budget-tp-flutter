import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/utils/nanoid.dart';

import 'budget.model.dart';

final class BudgetRepository implements CrudRepository<BudgetModel> {
  static const String tableName = 'budgets';
  static const String identifierPrefix = 'bd';

  static String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      periodicity INTEGER UNIQUE NOT NULL CHECK (periodicity IN (${BudgetPeriodicityEnum.weekly.id}, ${BudgetPeriodicityEnum.monthly.id}, ${BudgetPeriodicityEnum.trimesterly.id}, ${BudgetPeriodicityEnum.yearly.id})),
      amount REAL NOT NULL,

      currency_id TEXT NOT NULL,

      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT,

      FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_periodicity ON $tableName (periodicity);
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  Database? _database;

  BudgetRepository() {
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
  Future<List<BudgetModel>> findAll({bool includeDeleted = false}) async {
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future <List<BudgetModel>> findAllDeleted() async {
    final maps = await _database!.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<BudgetModel?> findById(String id, {bool includeDeleted = false}) async {
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? BudgetModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(BudgetModel budget) async {
    return await _database!.insert(
      tableName,
      {
        'id': NanoidUtils.generate(prefix: identifierPrefix),
        ...budget.toMap(),
        'created_at': DateTime.now().toIso8601String()
      }
    );
  }

  @override
  Future<int> update(BudgetModel budget) async {
    return await _database!.update(
      tableName,
      {
        ...budget.toMap(),
        'updated_at': DateTime.now().toIso8601String()
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> delete(BudgetModel budget) async {
    return await _database!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }

  @override
  Future<int> softDelete(BudgetModel budget) async {
    final String nowIso8601 = DateTime.now().toIso8601String();

    return await _database!.update(
      tableName,
      {
        'deleted_at': nowIso8601,
        'updated_at': nowIso8601
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> restore(BudgetModel budget) async {
    return await _database!.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': DateTime.now().toIso8601String()
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

}