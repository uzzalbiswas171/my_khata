class TransactionModel {
  final int? id;
  final String type; // 'income' or 'expense'
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'amount': amount,
    'category': category,
    'note': note,
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'],
        type: map['type'],
        amount: map['amount'],
        category: map['category'],
        note: map['note'],
        date: DateTime.parse(map['date']),
      );
}
