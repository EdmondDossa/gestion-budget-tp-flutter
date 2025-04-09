import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '/db/db.helper.dart';
import '/db/crud.repository.dart';

import 'budget.dart';
import 'category.repository.dart';

final class BudgetRepository implements CrudRepository<BudgetModel> {
  static const String tableName = 'budgets';

static String createTableQuery = '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    periodicity INTEGER CHECK (periodicity IN (${BudgetPeriodicityEnum.weekly.id}, ${BudgetPeriodicityEnum.monthly.id}, ${BudgetPeriodicityEnum.trimesterly.id}, ${BudgetPeriodicityEnum.yearly.id})),
    amount REAL NOT NULL,
    currency_code TEXT NOT NULL,
    observation TEXT,
    category_id INTEGER NOT NULL,

    created_at TEXT NOT NULL,
    updated_at TEXT,
    deleted_at TEXT,

    UNIQUE(category_id, periodicity),
    FOREIGN KEY (category_id) REFERENCES ${CategoryRepository.tableName}(id) ON DELETE CASCADE
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
  }

  Future<Database> _getDb() async {
    _database ??= await DBHelper().database;
    return _database!;
  }

  @override
  Future<List<BudgetModel>> findAll({ bool includeDeleted = false }) async {
    final db = await _getDb();

  final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        b.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName b
      INNER JOIN ${CategoryRepository.tableName} c ON b.category_id = c.id
      ${includeDeleted ? '' : 'WHERE b.deleted_at IS NULL'}
    ''');

    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<List<BudgetModel>> findAllDeleted() async {
    final db = await _getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        b.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName b
      INNER JOIN ${CategoryRepository.tableName} c ON b.category_id = c.id
      WHERE b.deleted_at IS NOT NULL
    ''');

    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<BudgetModel?> findById(int id, { bool includeDeleted = false }) async {
    final db = await _getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        b.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName b
      INNER JOIN ${CategoryRepository.tableName} c ON b.category_id = c.id
      WHERE b.id = ? ${includeDeleted ? '' : 'AND b.deleted_at IS NULL'}
    ''', [id]);

    return maps.isNotEmpty ? BudgetModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(BudgetModel budget) async {
    final now = DateTime.now().toIso8601String();
    
    final db = await _getDb();

    try {
      return await db.insert(
        tableName,
        {
          ...budget.toMap(),
          'created_at': now,
          'updated_at': now
        },
      );
    } on DatabaseException catch (exception) {
      if (exception.isUniqueConstraintError()) {
        throw Exception('A budget with this periodicity, in this category, already exists.');
      }
      rethrow;
    }
  }

  @override
  Future<int> update(BudgetModel budget) async {
    final now = DateTime.now().toIso8601String();
    
    final db = await _getDb();

    return await db.update(
      tableName,
      {
        ...budget.toMap(),
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }

  @override
  Future<int> delete(BudgetModel budget) async {
    final db = await _getDb();

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }

  @override
  Future<int> softDelete(BudgetModel budget) async {
    final now = DateTime.now().toIso8601String();
    
    final db = await _getDb();

    return await db.update(
      tableName,
      {
        'deleted_at': now,
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }

  @override
  Future<int> restore(BudgetModel budget) async {
    final now = DateTime.now().toIso8601String();
    
    final db = await _getDb();

    return await db.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': now
      },
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }
}