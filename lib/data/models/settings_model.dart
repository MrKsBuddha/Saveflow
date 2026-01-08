import 'package:hive/hive.dart';
import 'package:saveflow/core/constants/hive_constants.dart';

part 'settings_model.g.dart';

@HiveType(typeId: HiveConstants.settingsTypeId)
class AppSettings extends HiveObject {
  @HiveField(0)
  final double monthlyLimit;

  @HiveField(1)
  final int monthStartDay;

  @HiveField(2)
  final double currentSavings;

  @HiveField(3)
  final double currentDebt;

  // New field to track the last opened month for auto-closing logic
  @HiveField(4)
  final String? lastOpenedMonth; 

  AppSettings({
    this.monthlyLimit = 1000.0,
    this.monthStartDay = 1,
    this.currentSavings = 0.0,
    this.currentDebt = 0.0,
    this.lastOpenedMonth,
  });

  AppSettings copyWith({
    double? monthlyLimit,
    int? monthStartDay,
    double? currentSavings,
    double? currentDebt,
    String? lastOpenedMonth,
  }) {
    return AppSettings(
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      currentSavings: currentSavings ?? this.currentSavings,
      currentDebt: currentDebt ?? this.currentDebt,
      lastOpenedMonth: lastOpenedMonth ?? this.lastOpenedMonth,
    );
  }
}
