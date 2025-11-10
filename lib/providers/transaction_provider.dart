import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/local_db_service.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = await LocalDBService.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await LocalDBService.insertTransaction(tx);
    await loadTransactions();
  }

  double get totalIncome => _transactions
      .where((e) => e.type == 'income')
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => _transactions
      .where((e) => e.type == 'expense')
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;
}
