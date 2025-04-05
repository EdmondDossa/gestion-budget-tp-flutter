import 'package:flutter/material.dart';

class IncomesScreen extends StatelessWidget {

  static const String title = 'Incomes';
  static const String routeName = '/incomes';

  const IncomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Incomes Screen'),
      ),
    );
  }
}
