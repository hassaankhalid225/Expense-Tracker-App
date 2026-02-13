
import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../database/database_helper.dart';
import '../utils/constants.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    _expenses = await DatabaseHelper.instance.readAllExpenses();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(double amount, ExpenseCategory category, DateTime date, String description) async {
    final newExpense = Expense(
      id: const Uuid().v4(),
      amount: amount,
      category: category,
      date: date,
      description: description,
      createdAt: DateTime.now(),
    );

    await DatabaseHelper.instance.create(newExpense);
    _expenses.add(newExpense);
    // Re-sort locally to avoid refetching
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await DatabaseHelper.instance.delete(id);
    _expenses.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> clearAllExpenses() async {
    await DatabaseHelper.instance.deleteAll();
    _expenses.clear();
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper.instance.update(expense);
    final index = _expenses.indexWhere((element) => element.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  double get totalExpenses {
    return _expenses.fold(0.0, (previousValue, element) => previousValue + element.amount);
  }

  double get monthlyTotal {
    final now = DateTime.now();
    return _expenses
        .where((element) => element.date.month == now.month && element.date.year == now.year)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
  }

  Map<ExpenseCategory, double> get categoryBreakdown {
    final map = <ExpenseCategory, double>{};
    for (var expense in _expenses) {
      if (map.containsKey(expense.category)) {
        map[expense.category] = map[expense.category]! + expense.amount;
      } else {
        map[expense.category] = expense.amount;
      }
    }
    return map;
  }
}
