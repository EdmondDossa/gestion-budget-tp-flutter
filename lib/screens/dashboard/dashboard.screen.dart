import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {

  static const String title = 'Dashboard';
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}
