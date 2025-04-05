import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {

  static const String title = 'Expenses';
  static const String routeName = '/expenses';

  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const Center(
        child: Text('Expenses Screen'),
      ),
    );
  }
}
