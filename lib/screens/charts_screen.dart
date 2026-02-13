
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpenseProvider>(context);
    var categoryBreakdown = expenseProvider.categoryBreakdown;
    
    // Filter only expenses (negative values) and convert to positive for chart
    var expenseCategories = categoryBreakdown.entries
        .where((e) => e.value < 0)
        .map((e) => MapEntry(e.key, e.value.abs()))
        .toList();
        
    var totalSpending = expenseCategories.fold(0.0, (sum, item) => sum + item.value);

    return Center(
      child: totalSpending == 0
          ? const Text('No expenses to show charts.')
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Expenses Breakdown',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: expenseCategories.map((entry) {
                          return PieChartSectionData(
                            color: entry.key.color,
                            value: entry.value,
                            title: '${(entry.value / totalSpending * 100).toStringAsFixed(1)}%',
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: ExpenseCategory.values.map((category) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: category.color,
                          ),
                          const SizedBox(width: 4),
                          Text(category.name),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
