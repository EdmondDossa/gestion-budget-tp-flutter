import 'package:flutter/material.dart';

class DashboardMainScreen extends StatelessWidget {

  static const String title = 'Dashboard';
  static const String routeName = '/dashboard';

  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}
