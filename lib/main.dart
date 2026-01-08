import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saveflow/core/theme/app_theme.dart';
import 'package:saveflow/data/repositories/expense_repository.dart';
import 'package:saveflow/data/repositories/history_repository.dart';
import 'package:saveflow/data/repositories/settings_repository.dart';
import 'package:saveflow/data/services/hive_service.dart';
import 'package:saveflow/logic/providers/core_providers.dart';
import 'package:saveflow/logic/services/month_closing_service.dart';
import 'package:saveflow/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:saveflow/presentation/screens/setup/setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  final settingsRepo = SettingsRepository(hiveService);
  final expenseRepo = ExpenseRepository(hiveService);
  final historyRepo = HistoryRepository(hiveService);
  
  final closingService = MonthClosingService(
    settingsRepo: settingsRepo,
    expenseRepo: expenseRepo,
    historyRepo: historyRepo,
  );

  final settings = settingsRepo.getSettings();
  bool isFirstRun = settings.lastOpenedMonth == null;

  if (!isFirstRun) {
    // Check for month closing if already set up
    await closingService.checkAndCloseMonths();
  }

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hiveService),
      ],
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveFlow',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: isFirstRun ? const SetupScreen() : const DashboardScreen(),
    );
  }
}
