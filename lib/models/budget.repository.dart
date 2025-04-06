import 'dart:io';
import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/utils/nanoid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'budget.dart';

final class BudgetRepository implements CrudRepository<BudgetModel> {
  static const String tableName = 'budgets';
  static const String identifierPrefix = 'bd';

  static String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      periodicity INTEGER UNIQUE CHECK (periodicity IN (${BudgetPeriodicityEnum.weekly.id}, ${BudgetPeriodicityEnum.monthly.id}, ${BudgetPeriodicityEnum.trimesterly.id}, ${BudgetPeriodicityEnum.yearly.id})),
      amount REAL NOT NULL,
      currency_code TEXT NOT NULL,
      observation TEXT,

      created_at TEXT NOT NULL,
      updated_at TEXT,
      deleted_at TEXT
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
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<List<BudgetModel>> findAllDeleted() async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<BudgetModel?> findById(String id, {bool includeDeleted = false}) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? BudgetModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(BudgetModel budget) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    try {
      return await _database!.insert(
        tableName,
        {
          'id': NanoidUtils.generate(prefix: identifierPrefix),
          ...budget.toMap(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('A budget with this periodicity already exists.');
      }
      rethrow;
    }
  }

  @override
  Future<int> update(BudgetModel budget) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.update(
      tableName,
      {
        ...budget.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> delete(BudgetModel budget) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> softDelete(BudgetModel budget) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final nowIso8601 = DateTime.now().toIso8601String();
    return await _database!.update(
      tableName,
      {
        'deleted_at': nowIso8601,
        'updated_at': nowIso8601,
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> restore(BudgetModel budget) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }
}