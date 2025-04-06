import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/utils/nanoid.dart';

import 'budget.dart';

import 'currency.repository.dart';

final class BudgetRepository implements CrudRepository<BudgetModel> {
  static const String tableName = 'budgets';
  static const String identifierPrefix = 'bd';

  static String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      periodicity INTEGER UNIQUE CHECK (periodicity IN (${BudgetPeriodicityEnum.weekly.id}, ${BudgetPeriodicityEnum.monthly.id}, ${BudgetPeriodicityEnum.trimesterly.id}, ${BudgetPeriodicityEnum.yearly.id})),
      amount REAL NOT NULL,
      currency_code TEXT NOT NULL,

      created_at TEXT NOT NULL,
      updated_at TEXT,
      deleted_at TEXT,

      FOREIGN KEY (currency_code) REFERENCES ${CurrencyRepository.tableName}(code) ON DELETE CASCADE ON UPDATE CASCADE
    )
  ''';

  static const String createIndexesQuery = '''
    CREATE INDEX IF NOT EXISTS idx_${tableName}_periodicity ON $tableName (periodicity);
    CREATE INDEX IF NOT EXISTS idx_${tableName}_deleted_at ON $tableName (deleted_at);
  ''';

  @override
  Future<List<BudgetModel>> findAll({bool includeDeleted = false}) async {
    final db = await DBHelper().database;

    final maps = await db.query(
      tableName,
      where: includeDeleted ? null : 'deleted_at IS NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<List<BudgetModel>> findAllDeleted() async {
    final db = await DBHelper().database;

    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NOT NULL',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  @override
  Future<BudgetModel?> findById(String id, {bool includeDeleted = false}) async {
    final db = await DBHelper().database;

    final maps = await db.query(
      tableName,
      where: includeDeleted ? 'id = ?' : 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? BudgetModel.fromMap(maps.first) : null;
  }

  @override
  Future<int> create(BudgetModel budget) async {
    final db = await DBHelper().database;

    return await db.insert(
      tableName,
      {
        'id': NanoidUtils.generate(prefix: identifierPrefix),
        ...budget.toMap()
      }
    );
  }

  @override
  Future<int> update(BudgetModel budget) async {
    final db = await DBHelper().database;

    return await db.update(
      tableName,
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<int> delete(BudgetModel budget) async {
    final db = await DBHelper().database;

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [budget.id]
    );
  }

  @override
  Future<int> softDelete(BudgetModel budget) async {
    final db = await DBHelper().database;
    final String nowIso8601 = DateTime.now().toIso8601String();

    return await db.update(
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
    final db = await DBHelper().database;
    return await db.update(
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