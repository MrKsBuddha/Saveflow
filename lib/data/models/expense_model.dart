import 'package:hive/hive.dart';
import 'package:saveflow/core/constants/hive_constants.dart';
import 'package:uuid/uuid.dart';

part 'expense_model.g.dart';

@HiveType(typeId: HiveConstants.expenseTypeId)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String reason;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool isBackdated;

  Expense({
    String? id,
    required this.amount,
    required this.reason,
    required this.date,
    this.isBackdated = false,
  }) : id = id ?? const Uuid().v4();
}
