import 'package:intl/intl.dart';
import 'package:saveflow/data/models/monthly_summary_model.dart';
import 'package:saveflow/data/repositories/expense_repository.dart';
import 'package:saveflow/data/repositories/history_repository.dart';
import 'package:saveflow/data/repositories/settings_repository.dart';

class MonthClosingService {
  final SettingsRepository settingsRepo;
  final ExpenseRepository expenseRepo;
  final HistoryRepository historyRepo;

  MonthClosingService({
    required this.settingsRepo,
    required this.expenseRepo,
    required this.historyRepo,
  });

  Future<void> checkAndCloseMonths() async {
    final settings = settingsRepo.getSettings();
    final now = DateTime.now();
    final currentMonthStr = DateFormat('yyyy-MM').format(now);
    
    // First run or migration
    if (settings.lastOpenedMonth == null) {
      // Just set current month and return
      final newSettings = settings.copyWith(lastOpenedMonth: currentMonthStr);
      await settingsRepo.updateSettings(newSettings);
      return;
    }

    String checkMonthStr = settings.lastOpenedMonth!;
    
    // If we are still in same month, do nothing
    if (checkMonthStr == currentMonthStr) return;

    // Loop until we reach current month
    // We need to iterate month by month.
    DateTime checkDate = DateFormat('yyyy-MM').parse(checkMonthStr);
    
    // Move to next month to start closing?
    // No, if lastOpened is "2025-11", and now is "2026-01", 
    // it means 2025-11 has ended. We need to close 2025-11. 
    // And then 2025-12 has ended. Close 2025-12.
    // 2026-01 is current, so it's open.
    
    while (true) {
       // Loop condition: As long as checkDate is BEFORE the start of current month
       // Actually simpler: iterate and process 'checkDate' if it is strictly before current month.
       // Then increment month.
       
       final nextMonthDate = DateTime(checkDate.year, checkDate.month + 1, 1);
       final nextMonthStr = DateFormat('yyyy-MM').format(nextMonthDate);
       
       // If the month we are checking is the current month, we stop.
       // Wait, if lastOpened is Nov, and now is Jan.
       // checkDate = Nov. Is Nov < Jan? Yes. Close Nov.
       // checkDate = Dec. Is Dec < Jan? Yes. Close Dec.
       // checkDate = Jan. Is Jan < Jan? No. Stop.
       
       if (checkMonthStr == currentMonthStr) break;
       
       // Verify if Date(checkMonth) < Date(currentMonth)
       // Comparing strings 'YYYY-MM' works lexicographically for ISO format
       if (checkMonthStr.compareTo(currentMonthStr) >= 0) break;

       // Close 'checkMonthStr'
       await _closeMonth(checkMonthStr);
       
       // Move to next month
       checkDate = nextMonthDate;
       checkMonthStr = nextMonthStr;
    }

    // Finally update lastOpenedMonth to current
    final newSettings = settingsRepo.getSettings().copyWith(lastOpenedMonth: currentMonthStr);
    await settingsRepo.updateSettings(newSettings);
  }

  Future<void> _closeMonth(String yearMonth) async {
    // 1. Check if already verified/closed in history? 
    // The requirement says "Closed months are locked". 
    // We can assume if it's in history, it's done.
    if (historyRepo.getMonthSummary(yearMonth) != null) return;

    final settings = settingsRepo.getSettings();
    final budget = settings.monthlyLimit; // Note: We use CURRENT settings budget. Historical budget tracking would require storing budget changes. Requirement: "Default applies from next month". 
    // Ideally we should have stored budget snapshot per month, but "Settings" is global.
    // Simplifying assumption: Use current budget for auto-closing or we'd need a budget history log. 
    // Let's stick to current budget as per simple spec, or maybe the budget that was active? 
    // Since we don't have budget history, we use current.
    
    final expenses = expenseRepo.getExpensesForMonth(yearMonth);
    double totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);

    double saved = 0;
    double debt = 0;

    if (totalSpent <= budget) {
      saved = budget - totalSpent;
      // Add to accumulated savings
      final newSavings = settings.currentSavings + saved;
      final newSettings = settings.copyWith(currentSavings: newSavings);
      await settingsRepo.updateSettings(newSettings);
    } else {
      double overage = totalSpent - budget;
      debt = 0; // Debt for this specific month tally? Or accumulated debt?
      // Logic: "deduct from savings -> if savings insufficient -> create debt"
      
      double remainingSavings = settings.currentSavings - overage;
      
      if (remainingSavings >= 0) {
        // Covered by savings
        final newSettings = settings.copyWith(currentSavings: remainingSavings);
        await settingsRepo.updateSettings(newSettings);
      } else {
        // Savings wiped out, remainder is debt
        double newDebtAmount = remainingSavings.abs(); // remainingSavings is negative
        double totalDebt = settings.currentDebt + newDebtAmount;
        
        final newSettings = settings.copyWith(currentSavings: 0, currentDebt: totalDebt);
        await settingsRepo.updateSettings(newSettings);
        
        // This month's debt contribution
        debt = newDebtAmount; 
      }
    }

    // Create Summary
    final summary = MonthlySummary(
      yearMonth: yearMonth,
      budget: budget,
      totalSpent: totalSpent,
      savedAmount: saved, // This is "saved THIS month" logic or "leftover".
      debtAmount: debt, // This is "debt incurred THIS month".
      isLocked: true,
    );

    await historyRepo.saveMonthSummary(summary);
  }
}
