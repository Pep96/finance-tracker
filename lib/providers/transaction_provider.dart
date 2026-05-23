import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

final transactionBoxProvider = Provider<Box<Transaction>>((ref) {
  return Hive.box<Transaction>('transactions');
});

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionNotifier(box);
});

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final month = ref.watch(selectedMonthProvider);
  return transactions
      .where((t) => t.date.year == month.year && t.date.month == month.month)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

final summaryProvider = Provider<({double income, double expense, double balance})>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  final income = transactions
      .where((t) => !t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);
  final expense = transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);
  return (income: income, expense: expense, balance: income - expense);
});

final categoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  final expenses = transactions.where((t) => t.isExpense);
  final Map<String, double> result = {};
  for (final t in expenses) {
    result[t.category] = (result[t.category] ?? 0) + t.amount;
  }
  return result;
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final Box<Transaction> _box;
  final _uuid = const Uuid();

  TransactionNotifier(this._box)
      : super(_box.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date)));

  void _refresh() {
    state = _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required bool isExpense,
    String? note,
  }) async {
    final t = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      isExpense: isExpense,
      note: note,
    );
    await _box.put(t.id, t);
    _refresh();
  }

  Future<void> update(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
    _refresh();
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
    _refresh();
  }
}
