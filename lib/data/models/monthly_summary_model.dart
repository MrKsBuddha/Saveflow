import 'package:hive/hive.dart';
import 'package:saveflow/core/constants/hive_constants.dart';

part 'monthly_summary_model.g.dart';

@HiveType(typeId: HiveConstants.monthlySummaryTypeId)
class MonthlySummary extends HiveObject {
  @HiveField(0)
  final String yearMonth; // Format: "YYYY-MM"

  @HiveField(1)
  final double budget;

  @HiveField(2)
  final double totalSpent;

  @HiveField(3)
  final double savedAmount;

  @HiveField(4)
  final double debtAmount;

  @HiveField(5)
  final bool isLocked;

  MonthlySummary({
    required this.yearMonth,
    required this.budget,
    required this.totalSpent,
    required this.savedAmount,
    required this.debtAmount,
    this.isLocked = true,
  });
}
