import 'package:flutter/material.dart';

class TransactionCategory {
  final String name;
  final IconData icon;
  final Color color;
  final bool isExpense;

  const TransactionCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.isExpense,
  });
}

class Categories {
  static const List<TransactionCategory> expense = [
    TransactionCategory(name: 'Food', icon: Icons.restaurant_rounded, color: Color(0xFFFF6B6B), isExpense: true),
    TransactionCategory(name: 'Transport', icon: Icons.directions_car_rounded, color: Color(0xFF4ECDC4), isExpense: true),
    TransactionCategory(name: 'Shopping', icon: Icons.shopping_bag_rounded, color: Color(0xFFFFBE0B), isExpense: true),
    TransactionCategory(name: 'Health', icon: Icons.favorite_rounded, color: Color(0xFFFF006E), isExpense: true),
    TransactionCategory(name: 'Entertainment', icon: Icons.movie_rounded, color: Color(0xFF8338EC), isExpense: true),
    TransactionCategory(name: 'Bills', icon: Icons.receipt_long_rounded, color: Color(0xFFFF9F1C), isExpense: true),
    TransactionCategory(name: 'Education', icon: Icons.school_rounded, color: Color(0xFF2196F3), isExpense: true),
    TransactionCategory(name: 'Other', icon: Icons.more_horiz_rounded, color: Color(0xFF9E9E9E), isExpense: true),
  ];

  static const List<TransactionCategory> income = [
    TransactionCategory(name: 'Salary', icon: Icons.work_rounded, color: Color(0xFF06D6A0), isExpense: false),
    TransactionCategory(name: 'Freelance', icon: Icons.laptop_rounded, color: Color(0xFF118AB2), isExpense: false),
    TransactionCategory(name: 'Investment', icon: Icons.trending_up_rounded, color: Color(0xFF073B4C), isExpense: false),
    TransactionCategory(name: 'Gift', icon: Icons.card_giftcard_rounded, color: Color(0xFFEF476F), isExpense: false),
    TransactionCategory(name: 'Other', icon: Icons.attach_money_rounded, color: Color(0xFF06D6A0), isExpense: false),
  ];

  static TransactionCategory? findByName(String name, bool isExpense) {
    final list = isExpense ? expense : income;
    try {
      return list.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }
}
