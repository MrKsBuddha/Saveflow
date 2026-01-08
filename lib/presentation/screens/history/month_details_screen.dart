import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:saveflow/data/models/monthly_summary_model.dart';
import 'package:saveflow/logic/providers/core_providers.dart';

class MonthDetailsScreen extends ConsumerWidget {
  final MonthlySummary summary;
  const MonthDetailsScreen({super.key, required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseRepo = ref.watch(expenseRepositoryProvider);
    final expenses = expenseRepo.getExpensesForMonth(summary.yearMonth);

    // Group expenses by category (Reason) for Chart?
    // User just inputs "Reason". If we group by "Reason" string, it works as categories.
    
    Map<String, double> categories = {};
    for (var e in expenses) {
      categories[e.reason] = (categories[e.reason] ?? 0) + e.amount;
    }

    final pieSections = categories.entries.map((e) {
      return PieChartSectionData(
        value: e.value,
        title: '',
        radius: 50,
        color: Colors.primaries[categories.keys.toList().indexOf(e.key) % Colors.primaries.length],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(summary.yearMonth)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Card
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Budget: ₹${summary.budget.toStringAsFixed(0)}'),
                        Text('Spent: ₹${summary.totalSpent.toStringAsFixed(0)}'),
                      ],
                    ),
                    const Divider(),
                    if (summary.savedAmount > 0)
                      Text(
                        'Saved: ₹${summary.savedAmount.toStringAsFixed(0)}', 
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    else
                      Text(
                        'Overspent: ₹${summary.debtAmount.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            // Chart
            if (pieSections.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: pieSections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const Gap(16),
              // Legend
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: categories.entries.map((e) {
                   final color = Colors.primaries[categories.keys.toList().indexOf(e.key) % Colors.primaries.length];
                   return Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Container(width: 12, height: 12, color: color),
                       const Gap(4),
                       Text('${e.key}: ₹${e.value.toStringAsFixed(0)}'),
                     ],
                   );
                }).toList(),
              ),
            ],
            const Gap(24),
            // Expense List
            const Align(alignment: Alignment.centerLeft, child: Text('Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Gap(8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.reason),
                  subtitle: Text(DateFormat('dd MMM').format(expense.date)),
                  trailing: Text('₹${expense.amount.toStringAsFixed(0)}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
