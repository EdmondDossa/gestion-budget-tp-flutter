import 'package:budgetti/db/crud.repository.dart';
import 'package:sqflite/sqflite.dart';
import 'budget.dart';

class BudgetRepository implements CrudRepository<Budget> {
  final Database database;
  static const String tableName = 'budgets';

  BudgetRepository({required this.database});
  
  @override
  Future<void> create(Budget item) async {
    final db = database; // Get the database instance
    await db.insert(
      tableName,
      item.toMap(), // Assuming Budget has a toMap() method
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  @override
  Future<void> delete(String id) async {
    final db = database; // Get the database instance
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<void> deleteAll() async {
    final db = database; // Get the database instance
    await db.delete(tableName); // Delete all records from the table
  }
  
  @override
  Future<List<Budget>> getAll() {
    final db = database; // Get the database instance
    return db.query(tableName).then((maps) {
      return List.generate(maps.length, (i) {
        return Budget.fromMap(maps[i]); // Assuming Budget has a fromMap() method
      });
    });
  }
  
  @override
  Future<Budget?> getById(String id) {
    final db = database; // Get the database instance
    return db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    ).then((maps) {
      if (maps.isNotEmpty) {
        return Budget.fromMap(maps.first); // Assuming Budget has a fromMap() method
      }
      return null; // Return null if no record is found
    });
  }
  
  @override
  Future<void> update(String id, Budget item) {
    final db = database; // Get the database instance
    return db.update(
      tableName,
      item.toMap(), // Assuming Budget has a toMap() method
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}