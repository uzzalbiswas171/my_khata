import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;

  const TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
        color: tx.type == 'income' ? Colors.green : Colors.red,
      ),
      title: Text(tx.category),
      subtitle: Text(tx.note),
      trailing: Text(
        '${tx.type == 'income' ? '+' : '-'}${tx.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: tx.type == 'income' ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
