import 'package:saveflow/data/models/settings_model.dart';
import 'package:saveflow/data/services/hive_service.dart';

class SettingsRepository {
  final HiveService _hiveService;

  SettingsRepository(this._hiveService);

  AppSettings getSettings() {
    final box = _hiveService.settingsBox;
    if (box.isEmpty) {
      final defaultSettings = AppSettings();
      box.put('settings', defaultSettings);
      return defaultSettings;
    }
    return box.get('settings')!;
  }

  Future<void> updateSettings(AppSettings settings) async {
    final box = _hiveService.settingsBox;
    await box.put('settings', settings);
  }
}
