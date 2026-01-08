import 'package:saveflow/data/models/expense_model.dart';
import 'package:saveflow/data/services/hive_service.dart';

class ExpenseRepository {
  final HiveService _hiveService;

  ExpenseRepository(this._hiveService);

  Future<void> addExpense(Expense expense) async {
    final box = _hiveService.expensesBox;
    await box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    final box = _hiveService.expensesBox;
    await box.delete(id);
  }

  List<Expense> getAllExpenses() {
    return _hiveService.expensesBox.values.toList();
  }

  /// Returns expenses for a specific "YYYY-MM" string.
  /// This requires filtering all expenses. Since data is local and likely < 10k items, this is fine.
  /// For larger datasets, we'd index or separate boxes.
  List<Expense> getExpensesForMonth(String yearMonth) {
    // Assuming yearMonth is "YYYY-MM"
    // Expense date to string and checking startsWith is inefficient but simple.
    // Better: check year and month integer.
    final parts = yearMonth.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    return _hiveService.expensesBox.values.where((e) {
      return e.date.year == year && e.date.month == month;
    }).toList();
  }
}
