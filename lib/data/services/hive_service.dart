import 'package:hive_flutter/hive_flutter.dart';
import 'package:saveflow/core/constants/hive_constants.dart';
import 'package:saveflow/data/models/expense_model.dart';
import 'package:saveflow/data/models/monthly_summary_model.dart';
import 'package:saveflow/data/models/settings_model.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(MonthlySummaryAdapter());

    await Hive.openBox<Expense>(HiveConstants.expenseBox);
    await Hive.openBox<AppSettings>(HiveConstants.settingsBox);
    await Hive.openBox<MonthlySummary>(HiveConstants.historyBox);
  }

  Box<Expense> get expensesBox => Hive.box<Expense>(HiveConstants.expenseBox);
  Box<AppSettings> get settingsBox => Hive.box<AppSettings>(HiveConstants.settingsBox);
  Box<MonthlySummary> get historyBox => Hive.box<MonthlySummary>(HiveConstants.historyBox);
}
