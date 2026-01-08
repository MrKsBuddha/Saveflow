import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saveflow/data/models/settings_model.dart';
import 'package:saveflow/logic/providers/core_providers.dart';

part 'settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AppSettings build() {
    // Sync read because Hive box is already open and settings are small
    return ref.read(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateBudget(double newBudget) async {
    final newSettings = state.copyWith(monthlyLimit: newBudget);
    await ref.read(settingsRepositoryProvider).updateSettings(newSettings);
    state = newSettings;
  }

  Future<void> updateMonthStartDay(int day) async {
    final newSettings = state.copyWith(monthStartDay: day);
    await ref.read(settingsRepositoryProvider).updateSettings(newSettings);
    state = newSettings;
  }
  
  Future<void> updateSavingsAndDebt({required double savings, required double debt}) async {
    final newSettings = state.copyWith(currentSavings: savings, currentDebt: debt);
    await ref.read(settingsRepositoryProvider).updateSettings(newSettings);
    state = newSettings;
  }

  Future<void> updateLastOpenedMonth(String month) async {
     final newSettings = state.copyWith(lastOpenedMonth: month);
     await ref.read(settingsRepositoryProvider).updateSettings(newSettings);
     state = newSettings;
  }
}
