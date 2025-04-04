import 'package:budgetti/screens/categories/categories.screen.dart';
import 'package:budgetti/screens/dashboard/dashboard.screen.dart';
import 'package:budgetti/screens/expenses/expenses.screen.dart';
import 'package:budgetti/screens/home.dart';
import 'package:budgetti/screens/incomes/incomes.screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
