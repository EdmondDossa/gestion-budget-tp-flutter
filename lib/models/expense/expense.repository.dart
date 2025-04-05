import 'dart:io';
import 'package:budgetti/db/crud.repository.dart';
import 'package:budgetti/db/db.helper.dart';
import 'package:budgetti/models/expense/expense.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ExpenseRepository implements CrudRepository<Expense> {
  Database? _database;

  ExpenseRepository() {
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
  Future<List<Expense>> getAll() async {
    final List<Map<String, dynamic>> maps = await _database!.query('expenses');

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  @override
  Future<Expense?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> create(Expense expense) async {
    await _database!.insert('depenses', expense.toMap());
  }

  @override
  Future<void> update(String id, Expense expense) async {
    await _database!.update(
      'depenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database!.delete(
      'depenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<void> deleteAll() async {
    await _database!.delete('depenses');
  }
}