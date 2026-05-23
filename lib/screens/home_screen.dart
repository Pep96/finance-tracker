import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/summary_cards.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final transactions = ref.watch(filteredTransactionsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _MonthSelector(month: month),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview', icon: Icon(Icons.pie_chart_rounded, size: 18)),
              Tab(text: 'Transactions', icon: Icon(Icons.list_rounded, size: 18)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(),
            _TransactionsTab(transactions: transactions),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ),
    );
  }
}

class _MonthSelector extends ConsumerWidget {
  final DateTime month;
  const _MonthSelector({required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            ref.read(selectedMonthProvider.notifier).state =
                DateTime(month.year, month.month - 1);
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(month),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final next = DateTime(month.year, month.month + 1);
            if (!next.isAfter(DateTime.now())) {
              ref.read(selectedMonthProvider.notifier).state = next;
            }
          },
        ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SummaryCards(),
        ExpensePieChart(),
        MonthlyBarChart(),
      ],
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  final List transactions;
  const _TransactionsTab({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 80, color: Theme.of(context).colorScheme.outline.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text('No transactions this month',
                style: TextStyle(color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: transactions.length,
      itemBuilder: (_, i) => TransactionTile(transaction: transactions[i] as dynamic),
    );
  }
}
