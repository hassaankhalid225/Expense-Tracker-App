
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  
  static const Color foodColor = Color(0xFFFF7043);
  static const Color travelColor = Color(0xFF42A5F5);
  static const Color billsColor = Color(0xFF7E57C2);
  static const Color incomeColor = Color(0xFF4CAF50);
}

enum ExpenseCategory {
  food,
  travel,
  bills,
  income,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.income:
        return 'Income';
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return AppColors.foodColor;
      case ExpenseCategory.travel:
        return AppColors.travelColor;
      case ExpenseCategory.bills:
        return AppColors.billsColor;
      case ExpenseCategory.income:
        return AppColors.incomeColor;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.travel:
        return Icons.directions_car;
      case ExpenseCategory.bills:
        return Icons.receipt;
      case ExpenseCategory.income:
        return Icons.attach_money;
    }
  }
}
