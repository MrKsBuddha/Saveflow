import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:saveflow/data/models/expense_model.dart';
import 'dart:math' as math;

class BudgetPieChart extends StatefulWidget {
  final List<Expense> expenses;
  final double budget;

  const BudgetPieChart({
    super.key,
    required this.expenses,
    required this.budget,
  });

  @override
  State<BudgetPieChart> createState() => _BudgetPieChartState();
}

class _BudgetPieChartState extends State<BudgetPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      // Just show empty budget ring? Or text? 
      // If budget exists, show 100% remaining?
      if (widget.budget > 0) {
          // Show full grey ring for budget
          return SizedBox(
            height: 250,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(color: Colors.grey.shade200, value: 100, radius: 50, title: ''),
                    ],
                    centerSpaceRadius: 60,
                    sectionsSpace: 0,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('0%', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('Used', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          );
      }
      return SizedBox(
        height: 250,
        child: Center(
          child: Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    // 1. Group expenses
    final Map<String, double> categories = {};
    double totalSpent = 0;
    
    for (var e in widget.expenses) {
      final category = e.reason.trim(); 
      categories[category] = (categories[category] ?? 0) + e.amount;
      totalSpent += e.amount;
    }
    
    // Sort categories
    final sortedEntries = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    // 2. Prepare visual data including Remaining
    final List<Color> sectionColors = [
      const Color(0xFF00796B), // Teal
      const Color(0xFF0288D1), // Light Blue
      const Color(0xFFFFA000), // Amber
      const Color(0xFFD32F2F), // Red
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFF388E3C), // Green
      const Color(0xFFF57C00), // Orange
      const Color(0xFF5D4037), // Brown
      const Color(0xFF455A64), // Blue Grey
    ];

    double remaining = widget.budget - totalSpent;
    bool isOverBudget = remaining < 0;
    
    // Create chart sections
    List<PieChartSectionData> sections = [];
    
    for (int i = 0; i < sortedEntries.length; i++) {
        final entry = sortedEntries[i];
        final isTouched = i == touchedIndex;
        final color = sectionColors[i % sectionColors.length];
        final radius = isTouched ? 60.0 : 50.0;
        
        sections.add(PieChartSectionData(
          color: color.withOpacity((touchedIndex != -1 && i != touchedIndex) ? 0.3 : 1.0),
          value: entry.value,
          title: '',
          radius: radius,
        ));
    }
    
    // Add Remaining Segment (if not over budget)
    if (!isOverBudget && remaining > 0) {
       // Remaining is index = sortedEntries.length
       final isTouched = touchedIndex == sortedEntries.length;
       sections.add(PieChartSectionData(
         color: Colors.grey.shade200.withOpacity((touchedIndex != -1 && !isTouched) ? 0.3 : 1.0),
         value: remaining,
         title: '',
         radius: isTouched ? 60.0 : 50.0,
       ));
    }

    return SizedBox(
      height: 250, 
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: sections,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getCenterLabel(totalSpent, remaining, sortedEntries),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _getCenterSubLabel(sortedEntries, remaining),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCenterLabel(double totalSpent, double remaining, List<MapEntry<String, double>> sortedEntries) {
    if (touchedIndex != -1) {
       // Check if category
       if (touchedIndex < sortedEntries.length) {
         final entry = sortedEntries[touchedIndex];
         return '₹ ${entry.value.toStringAsFixed(0)}';
       }
       // Else it is remaining (if exists)
       return '₹ ${remaining > 0 ? remaining.toStringAsFixed(0) : 0}';
    }
    
    // Default stats (Used %)
    if (widget.budget > 0) {
      final percentage = (totalSpent / widget.budget * 100).clamp(0, 999); // Allow >100%
      return '${percentage.toStringAsFixed(0)}%';
    }
    return '₹ ${totalSpent.toStringAsFixed(0)}';
  }

  String _getCenterSubLabel(List<MapEntry<String, double>> sortedEntries, double remaining) {
    if (touchedIndex != -1) {
       if (touchedIndex < sortedEntries.length) {
         final entry = sortedEntries[touchedIndex];
         return entry.key; // Category Name
       }
       return 'Remaining';
    }
    return 'Used';
  }
}
