import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saveflow/logic/providers/core_providers.dart';
import 'package:saveflow/presentation/screens/history/month_details_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyRepo = ref.watch(historyRepositoryProvider);
    final historyList = historyRepo.getAllHistory();

    // Also include Current Month? Or just closed months?
    // Requirement "Every month is saved permanently as history". Implies closed months.
    // Dashboard shows current. History shows past.

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: historyList.isEmpty
          ? const Center(child: Text('No history yet. Complete a month to see it here.'))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                // Show newest first
                final summary = historyList[historyList.length - 1 - index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(summary.yearMonth, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Spent: ₹${summary.totalSpent.toStringAsFixed(0)} / ${summary.budget.toStringAsFixed(0)}'),
                    trailing: summary.savedAmount > 0
                        ? Text(
                            '+ ₹${summary.savedAmount.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '- ₹${summary.debtAmount.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MonthDetailsScreen(summary: summary),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
