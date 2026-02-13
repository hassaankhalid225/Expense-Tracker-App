
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String description;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    required this.createdAt,
  });

  // Convert an Expense into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category.index, // Store enum as integer index
      'date': date.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Implement comparison for sorting
  int compareTo(Expense other) {
    if (date.isBefore(other.date)) {
      return 1;
    }
    if (date.isAfter(other.date)) {
      return -1;
    }
    return 0;
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: ExpenseCategory.values[map['category']],
      date: DateTime.parse(map['date']),
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String get formattedDate {
    return DateFormat.yMMMd().format(date);
  }
}
