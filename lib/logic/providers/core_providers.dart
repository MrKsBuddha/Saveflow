import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saveflow/data/repositories/expense_repository.dart';
import 'package:saveflow/data/repositories/history_repository.dart';
import 'package:saveflow/data/repositories/settings_repository.dart';
import 'package:saveflow/data/services/hive_service.dart';

// Initialized in main.dart
final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('HiveService must be overridden in main');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return SettingsRepository(hiveService);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ExpenseRepository(hiveService);
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return HistoryRepository(hiveService);
});
