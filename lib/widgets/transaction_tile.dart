import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/transaction_provider.dart';

class TransactionTile extends ConsumerWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final category = Categories.findByName(transaction.category, transaction.isExpense);
    final color = category?.color ?? theme.colorScheme.primary;
    final fmt = NumberFormat.currency(symbol: 'R\$ ', decimalDigits: 2);
    final dateFmt = DateFormat('MMM d');

    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                ref.read(transactionsProvider.notifier).delete(transaction.id),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(category?.icon ?? Icons.attach_money, color: color, size: 22),
        ),
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${transaction.category} • ${dateFmt.format(transaction.date)}',
          style: TextStyle(color: theme.colorScheme.outline, fontSize: 12),
        ),
        trailing: Text(
          '${transaction.isExpense ? '-' : '+'}${fmt.format(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: transaction.isExpense
                ? const Color(0xFFFF6B6B)
                : const Color(0xFF06D6A0),
          ),
        ),
      ),
    );
  }
}
