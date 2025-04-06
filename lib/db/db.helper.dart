import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:budgetti/models/budget.repository.dart';
import 'package:budgetti/models/category.repository.dart';
import 'package:budgetti/models/currency.repository.dart';
import 'package:budgetti/models/transaction.repository.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'budgetti.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.transaction((txn) async {

      // Create the currencies table and indexes if they don't exist
      await txn.execute(CategoryRepository.createTableQuery);
      await txn.execute(CategoryRepository.createIndexesQuery);

      // Create the budgets table and indexes if they don't exist
      await txn.execute(BudgetRepository.createTableQuery);
      await txn.execute(BudgetRepository.createIndexesQuery);

      // Create the transactions table and indexes if they don't exist
      await txn.execute(TransactionRepository.createTableQuery);
      await txn.execute(TransactionRepository.createIndexesQuery);

      /// Create the currencies table and indexes if they don't exist
      await txn.execute(CurrencyRepository.createTableQuery);
      await txn.execute(CurrencyRepository.createIndexesQuery);
      
    });
  }
}
