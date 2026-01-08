import 'package:saveflow/data/models/monthly_summary_model.dart';
import 'package:saveflow/data/services/hive_service.dart';

class HistoryRepository {
  final HiveService _hiveService;

  HistoryRepository(this._hiveService);

  Future<void> saveMonthSummary(MonthlySummary summary) async {
    final box = _hiveService.historyBox;
    await box.put(summary.yearMonth, summary);
  }

  MonthlySummary? getMonthSummary(String yearMonth) {
    return _hiveService.historyBox.get(yearMonth);
  }

  List<MonthlySummary> getAllHistory() {
    return _hiveService.historyBox.values.toList()..sort((a, b) => a.yearMonth.compareTo(b.yearMonth));
  }
}
