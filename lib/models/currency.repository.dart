import 'dart:io';

import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'currency.dart';

final class CurrencyRepository implements CrudRepository<CurrencyModel> {
  static const String tableName = 'currencies';
  static const String identifierPrefix = 'cur';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      code TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      symbol TEXT,
      decimal_digits INTEGER,
      symbol_native TEXT,
      rounding REAL,
      name_plural TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT
    )
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  Database? _database;

  CurrencyRepository() {
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
  Future<List<CurrencyModel>> findAll({bool includeDeleted = false}) async {
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => CurrencyModel.fromMap(map)).toList();
  }

  @override
  Future<List<CurrencyModel>> findAllDeleted() async {
    final maps = await _database!.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => CurrencyModel.fromMap(map)).toList();
  }

  @override
  Future<CurrencyModel?> findById(String code, {bool includeDeleted = false}) async {
    final maps = await _database!.query(
      tableName,
      where: includeDeleted ? 'code = ?' : 'code = ? AND deleted_at IS NULL',
      whereArgs: [code],
    );
    return maps.isNotEmpty ? CurrencyModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(CurrencyModel currency) async {
    return await _database!.insert(
      tableName,
      {
        ...currency.toMap(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
    );
  }

  @override
  Future<int> update(CurrencyModel currency) async {
    return await _database!.update(
      tableName,
      {
        ...currency.toMap(),
        'updated_at': DateTime.now().toIso8601String()
      },
      where: 'code = ?',
      whereArgs: [currency.code],
    );
  }

  @override
  Future<int> delete(CurrencyModel currency) async {
    return await _database!.delete(
      tableName,
      where: 'code = ?',
      whereArgs: [currency.code],
    );
  }

  @override
  Future<int> softDelete(CurrencyModel currency) async {
    final now = DateTime.now().toIso8601String();
    return await _database!.update(
      tableName,
      {
        'deleted_at': now,
        'updated_at': now
      },
      where: 'code = ?',
      whereArgs: [currency.code],
    );
  }

  @override
  Future<int> restore(CurrencyModel currency) async {
    return await _database!.update(
      tableName,
      {
        'deleted_at': null,
        'updated_at': DateTime.now().toIso8601String()
      },
      where: 'code = ?',
      whereArgs: [currency.code],
    );
  }
}
