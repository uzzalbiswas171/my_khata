import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = provider.transactions.where(
      (t) =>
          t.date.month == _selectedMonth.month &&
          t.date.year == _selectedMonth.year,
    );

    // group by category
    final Map<String, double> expenseByCategory = {};
    for (final tx in transactions) {
      if (tx.type == 'expense') {
        expenseByCategory[tx.category] =
            (expenseByCategory[tx.category] ?? 0) + tx.amount;
      }
    }

    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;
    final balance = provider.balance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickMonth,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat.yMMM().format(_selectedMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Summary cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard('Income', totalIncome, Colors.green),
                _summaryCard('Expense', totalExpense, Colors.red),
                _summaryCard(
                  'Balance',
                  balance,
                  balance >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chart section
            Expanded(
              child: expenseByCategory.isEmpty
                  ? const Center(child: Text('No data this month'))
                  : PieChart(
                      PieChartData(
                        sections: expenseByCategory.entries.map((e) {
                          final percent = (e.value / totalExpense * 100)
                              .toStringAsFixed(1);
                          return PieChartSectionData(
                            value: e.value,
                            title: '$percent%',
                            color:
                                Colors.primaries[e.key.hashCode %
                                    Colors.primaries.length],
                            radius: 70,
                            badgeWidget: Text(
                              e.key,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
            ),

            // Legend
            if (expenseByCategory.isNotEmpty)
              Wrap(
                alignment: WrapAlignment.center,
                children: expenseByCategory.keys
                    .map(
                      (k) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Chip(
                          label: Text(k),
                          backgroundColor: Colors
                              .primaries[k.hashCode % Colors.primaries.length],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double value, Color color) => Card(
    color: color.withOpacity(0.1),
    child: Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    ),
  );

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      helpText: 'Select Month',
    );
    if (picked != null) {
      setState(() => _selectedMonth = picked);
    }
  }
}
