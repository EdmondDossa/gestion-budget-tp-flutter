import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:budgetti/models/budget.repository.dart';
import 'package:budgetti/models/category.repository.dart';
import 'package:budgetti/models/currency.repository.dart';
import 'package:budgetti/models/transaction.repository.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = join(await getDatabasesPath(), 'budgetti.db');
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      // 1. Currencies
      await txn.execute(CurrencyRepository.createTableQuery);
      await txn.execute(CurrencyRepository.createIndexesQuery);

      // 2. Categories
      await txn.execute(CategoryRepository.createTableQuery);
      await txn.execute(CategoryRepository.createIndexesQuery);

      // 3. Budgets (depends on currencies)
      await txn.execute(BudgetRepository.createTableQuery);
      await txn.execute(BudgetRepository.createIndexesQuery);

      // 4. Transactions (depends on budgets and categories)
      await txn.execute(TransactionRepository.createTableQuery);
      await txn.execute(TransactionRepository.createIndexesQuery);
    });
  }
}
