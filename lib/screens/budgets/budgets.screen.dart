import 'package:flutter/material.dart';

class BudgetsScreen extends StatelessWidget {

  static const String title = 'Budgets';
  static const String routeName = '/budgets';

  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const Center(
        child: Text('Budgets Screen'),
      ),
    );
  }
}