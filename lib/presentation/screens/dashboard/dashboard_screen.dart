import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:saveflow/logic/notifiers/expense_notifier.dart';
import 'package:saveflow/logic/notifiers/settings_notifier.dart';
import 'package:saveflow/presentation/screens/add_expense/add_expense_sheet.dart';
import 'package:saveflow/presentation/screens/history/history_screen.dart';
import 'package:saveflow/presentation/screens/settings/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final expenses = ref.watch(currentMonthExpensesProvider);
    
    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final budget = settings.monthlyLimit;
    final remaining = budget - totalSpent;
    final progress = (budget > 0) ? (totalSpent / budget).clamp(0.0, 1.0) : 0.0;

    final now = DateTime.now();
    // Month label shows only name (e.g. January) since Year is in the header
    final monthLabel = DateFormat('MMMM').format(now); 
    final todayFull = DateFormat('EEEE • d MMMM yyyy').format(now); // Tuesday • 9 Jan 2026

    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveFlow'),
        centerTitle: true,
        actions: [
           IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddExpenseSheet(),
          );
        },
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Today's Date Header
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                todayFull,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Savings Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Savings', style: Theme.of(context).textTheme.titleMedium),
                        const Gap(5),
                        Text(
                          '₹ ${settings.currentSavings.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    if (settings.currentDebt > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Debt', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
                          const Gap(5),
                          Text(
                            '₹ ${settings.currentDebt.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Gap(20),
            // Budget Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(monthLabel, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const Gap(20),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: remaining < 0 ? Colors.red : Theme.of(context).colorScheme.primary,
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text('Used', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                         _StatItem(
                           label: 'Budget', 
                           value: '₹ ${budget.toStringAsFixed(0)}', 
                           color: Colors.black,
                        ),
                         _StatItem(
                           label: 'Spent', 
                           value: '₹ ${totalSpent.toStringAsFixed(0)}', 
                           color: Colors.orange,
                        ),
                         _StatItem(
                           label: 'Left', 
                           value: '₹ ${remaining.toStringAsFixed(0)}', 
                           color: remaining < 0 ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
            // Recent Expenses List (Condensed)
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Expenses', style: Theme.of(context).textTheme.titleMedium),
            ),
            const Gap(10),
            expenses.isEmpty 
              ? const Padding(padding: EdgeInsets.all(16), child: Text('No expenses yet.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length > 5 ? 5 : expenses.length,
                  itemBuilder: (context, index) {
                    // Show latest first
                    final sorted = List.of(expenses)..sort((a, b) => b.date.compareTo(a.date));
                    final expense = sorted[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          child: Icon(Icons.receipt, color: Theme.of(context).colorScheme.onSecondaryContainer),
                        ),
                        title: Text(
                          expense.reason,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(DateFormat('d MMM').format(expense.date)),
                        trailing: Text(
                          '- ₹ ${expense.amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
            // Bottom Padding for FAB
            const Gap(80),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Gap(4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
      ],
    );
  }
}
