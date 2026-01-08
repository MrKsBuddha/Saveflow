import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saveflow/data/models/expense_model.dart';
import 'package:saveflow/logic/providers/core_providers.dart';

part 'expense_notifier.g.dart';

@riverpod
class ExpenseNotifier extends _$ExpenseNotifier {
  @override
  List<Expense> build() {
    // Load ALL expenses by default, or maybe filter by month in UI?
    // For Dashboard we need current month.
    // Let's filter in the UI or create a separate provider for "currentMonthExpenses".
    // Actually, storing global list here is fine for small apps.
    return ref.read(expenseRepositoryProvider).getAllExpenses();
  }

  Future<void> addExpense({required double amount, required String reason, required DateTime date}) async {
    final expense = Expense(
      amount: amount,
      reason: reason,
      date: date,
    );
    await ref.read(expenseRepositoryProvider).addExpense(expense);
    // Refresh list
    state = ref.read(expenseRepositoryProvider).getAllExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(id);
    state = ref.read(expenseRepositoryProvider).getAllExpenses();
  }
}

// Derived Provider for Current Month Expenses
@riverpod
List<Expense> currentMonthExpenses(CurrentMonthExpensesRef ref) {
  final allExpenses = ref.watch(expenseNotifierProvider);
  final now = DateTime.now();
  // Filter by simple calendar month for now. 
  // User req: "Month start day (default 1)".
  // If start day is not 1, we need complex logic.
  // We should read settings to know the start day.
  
  // TODO: Implement custom start day logic properly.
  // For now, let's assume calendar month 1-31.
  
  return allExpenses.where((e) => e.date.year == now.year && e.date.month == now.month).toList();
}
