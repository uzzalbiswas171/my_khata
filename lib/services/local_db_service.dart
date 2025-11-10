import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

class LocalDBService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_khata.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            amount REAL,
            category TEXT,
            note TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertTransaction(TransactionModel tx) async {
    final db = await database;
    return db.insert('transactions', tx.toMap());
  }

  static Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final data = await db.query('transactions', orderBy: 'date DESC');
    return data.map((e) => TransactionModel.fromMap(e)).toList();
  }
}
