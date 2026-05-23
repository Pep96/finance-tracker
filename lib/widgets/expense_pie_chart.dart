import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/transaction_provider.dart';

class ExpensePieChart extends ConsumerStatefulWidget {
  const ExpensePieChart({super.key});

  @override
  ConsumerState<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends ConsumerState<ExpensePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final breakdown = ref.watch(categoryBreakdownProvider);

    if (breakdown.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No expense data for this month'),
        ),
      );
    }

    final entries = breakdown.entries.toList();
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expenses by Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex = response
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sections: entries.asMap().entries.map((e) {
                          final isTouched = e.key == _touchedIndex;
                          final category = Categories.findByName(e.value.key, true);
                          final color = category?.color ??
                              Colors.primaries[e.key % Colors.primaries.length];
                          final pct = (e.value.value / total * 100);
                          return PieChartSectionData(
                            value: e.value.value,
                            title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
                            color: color,
                            radius: isTouched ? 70 : 60,
                            titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        }).toList(),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entries.asMap().entries.map((e) {
                      final category = Categories.findByName(e.value.key, true);
                      final color = category?.color ??
                          Colors.primaries[e.key % Colors.primaries.length];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  color: color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(e.value.key,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
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
