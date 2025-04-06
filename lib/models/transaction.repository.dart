import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/utils/nanoid.dart';

import 'category.dart';
import 'category.repository.dart';

import 'transaction.dart';

final class TransactionRepository implements CrudRepository<TransactionModel> {

  static const String tableName = 'transactions';
  static const String identifierPrefix = 'tr';

  static String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      type INTEGER NOT NULL CHECK (type IN (${TransactionTypeEnum.income.id}, ${TransactionTypeEnum.expense.id})),
      title TEXT NOT NULL,
      description TEXT,
      amount REAL NOT NULL,
      timestamp TEXT NOT NULL,

      currency_code TEXT NOT NULL,
      category_id TEXT,

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

    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await DBHelper().database;
  }

  @override
  Future<List<TransactionModel>> findAll({bool includeDeleted = false}) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> findAllDeleted() async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<TransactionModel?> findById(String id, {bool includeDeleted = false}) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? TransactionModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(TransactionModel transaction) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.insert(tableName, {
      'id': NanoidUtils.generate(prefix: identifierPrefix),
      ...transaction.toMap(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<int> update(TransactionModel transaction) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.update(
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
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> softDelete(TransactionModel transaction) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.update(
      tableName,
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> restore(TransactionModel transaction) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    return await _database!.update(
      tableName,
      {'deleted_at': null},
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<List<TransactionModel>> findByType(TransactionTypeEnum type) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'type = ?',
      whereArgs: [type.id],
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> findByCategory(CategoryModel category) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'category_id = ?',
      whereArgs: [category.id],
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> findByCurrency(String currencyCode) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'currency_code = ?',
      whereArgs: [currencyCode],
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> findByDateRange(DateTime startDate, DateTime endDate) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final maps = await _database!.query(
      tableName,
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

}