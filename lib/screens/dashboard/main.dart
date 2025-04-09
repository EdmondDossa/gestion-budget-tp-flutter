import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends StatefulWidget {
  static const String title = 'Dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(DashboardScreen.title, style: theme.textTheme.h4),
        centerTitle: false,
      ),
      body: Center(
        child: Text('Bienvenue sur le Dashboard', style: theme.textTheme.h4),
      ),
    );
  }
}