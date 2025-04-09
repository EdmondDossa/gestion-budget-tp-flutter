import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '/db/db.helper.dart';
import '/db/crud.repository.dart';

import 'transaction.dart';
import 'category.dart';
import 'category.repository.dart';

final class TransactionRepository implements CrudRepository<TransactionModel> {
  static const String tableName = 'transactions';

  static String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type INTEGER NOT NULL CHECK (type IN (${TransactionTypeEnum.income.id}, ${TransactionTypeEnum.expense.id})),
      title TEXT NOT NULL,
      description TEXT,
      amount REAL NOT NULL,
      timestamp TEXT NOT NULL,
      currency_code TEXT NOT NULL,
      category_id INTEGER,

      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT,

      FOREIGN KEY (category_id) REFERENCES ${CategoryRepository.tableName}(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_type ON $tableName (type);
    CREATE INDEX IF NOT EXISTS idx_${tableName}_timestamp ON $tableName (timestamp);
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  Database? _database;

  TransactionRepository() {
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
  Future<List<TransactionModel>> findAll({bool includeDeleted = false}) async {
    final db = await _getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName t
      LEFT JOIN ${CategoryRepository.tableName} c ON t.category_id = c.id
      ${includeDeleted ? '' : 'WHERE t.deleted_at IS NULL'}
    ''');

    return maps.map(TransactionModel.fromMap).toList();
  }

  @override
  Future<List<TransactionModel>> findAllDeleted() async {
    final db = await _getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName t
      LEFT JOIN ${CategoryRepository.tableName} c ON t.category_id = c.id
      WHERE t.deleted_at IS NOT NULL
    ''');

    return maps.map(TransactionModel.fromMap).toList();
  }

  @override
  Future<TransactionModel?> findById(int id, {bool includeDeleted = false}) async {
    final db = await _getDb();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.*,
        c.name AS category_name,
        c.description AS category_description,
        c.created_at AS category_created_at,
        c.updated_at AS category_updated_at,
        c.deleted_at AS category_deleted_at
      FROM $tableName t
      LEFT JOIN ${CategoryRepository.tableName} c ON t.category_id = c.id
      WHERE t.id = ? ${includeDeleted ? '' : 'AND t.deleted_at IS NULL'}
    ''', [id]);

    return maps.isNotEmpty ? TransactionModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(TransactionModel transaction) async {
    final db = await _getDb();
    final now = DateTime.now().toIso8601String();

    return await db.insert(
      tableName,
      {
        ...transaction.toMap(),
        'created_at': now,
        'updated_at': now,
      },
    );
  }

  @override
  Future<int> update(TransactionModel transaction) async {
    final db = await _getDb();
    return await db.update(
      tableName,
      {
        ...transaction.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> delete(TransactionModel transaction) async {
    final db = await _getDb();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> softDelete(TransactionModel transaction) async {
    final db = await _getDb();
    final now = DateTime.now().toIso8601String();
    return await db.update(
      tableName,
      {
        'deleted_at': now,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> restore(TransactionModel transaction) async {
    final db = await _getDb();
    final now = DateTime.now().toIso8601String();
    return await db.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Extra queries
  Future<List<TransactionModel>> findByType(TransactionTypeEnum type) async {
    final db = await _getDb();
    final maps = await db.query(
      tableName,
      where: 'type = ?',
      whereArgs: [type.id],
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  Future<List<TransactionModel>> findByCategory(CategoryModel category) async {
    final db = await _getDb();
    final maps = await db.query(
      tableName,
      where: 'category_id = ?',
      whereArgs: [category.id],
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  Future<List<TransactionModel>> findByCurrency(String currencyCode) async {
    final db = await _getDb();
    final maps = await db.query(
      tableName,
      where: 'currency_code = ?',
      whereArgs: [currencyCode],
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  Future<List<TransactionModel>> findByDateRange(DateTime start, DateTime end) async {
    final db = await _getDb();
    final maps = await db.query(
      tableName,
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return maps.map(TransactionModel.fromMap).toList();
  }
}