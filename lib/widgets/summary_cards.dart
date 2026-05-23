import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class SummaryCards extends ConsumerWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summaryProvider);
    final fmt = NumberFormat.currency(symbol: 'R\$ ', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _BalanceCard(balance: summary.balance, fmt: fmt),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniCard(
                  label: 'Income',
                  amount: summary.income,
                  color: AppTheme.incomeColor,
                  icon: Icons.arrow_downward_rounded,
                  fmt: fmt,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniCard(
                  label: 'Expenses',
                  amount: summary.expense,
                  color: AppTheme.expenseColor,
                  icon: Icons.arrow_upward_rounded,
                  fmt: fmt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final NumberFormat fmt;

  const _BalanceCard({required this.balance, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            fmt.format(balance),
            style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final NumberFormat fmt;

  const _MiniCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline)),
                  Text(
                    fmt.format(amount),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: color, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
