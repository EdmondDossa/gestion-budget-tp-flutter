import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/db/db.helper.dart';
import 'budget.dart';

final class BudgetRepository implements CrudRepository<Budget, int> {
  
  Database? _database;
  static const String tableName = 'budgets';

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
  Future<List<Budget>> getAll() async {
    final maps = await _database!.query(tableName);
    return maps.map((map) => Budget.fromMap(map)).toList();
  }

  @override
  Future<Budget?> getById(int id) async {
    final maps = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? Budget.fromMap(maps.first) : null;
  }

  @override
  Future<void> create(Budget budget) async {
    await _database!.insert(tableName, budget.toMap());
  }

  @override
  Future<void> update(int id, Budget budget) async {
    await _database!.update(
      tableName,
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(int id) async {
    await _database!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _database!.delete(tableName);
  }

  @override
  Future<void> save(Budget budget) async {
    if (budget.id == null) {
      final newBudget = Budget.create(
        name: budget.name,
        description: budget.description,
        periodicity: budget.periodicity,
        amount: budget.amount,
      );

      await create(newBudget);
    } else {
      final updatedBudget = Budget.update(
        id: budget.id!,
        name: budget.name,
        description: budget.description,
        periodicity: budget.periodicity,
        amount: budget.amount,
      );

      await update(budget.id!, updatedBudget);
    }
  }

}