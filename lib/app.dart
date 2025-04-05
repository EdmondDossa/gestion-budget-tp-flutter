import 'package:flutter/material.dart';

import 'screens/categories/categories.screen.dart';
import 'screens/dashboard/dashboard.screen.dart';
import 'screens/expenses/expenses.screen.dart';
import 'screens/budgets/budgets.screen.dart';
import 'screens/incomes/incomes.screen.dart';

import 'widgets/custom_navigation_bar.dart';

import 'app.themes.dart';
import 'app.constants.dart';

Future<void> initApp() async {
  // Initialize any necessary services or configurations here
  // For example, you might want to initialize a database or a network client
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    IncomesScreen(),
    ExpensesScreen(),
    CategoriesScreen(),
    BudgetsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: DashboardScreen.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on_outlined),
      activeIcon: Icon(Icons.monetization_on),
      label: IncomesScreen.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: ExpensesScreen.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category_outlined),
      activeIcon: Icon(Icons.category),
      label: CategoriesScreen.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart_outline_outlined),
      activeIcon: Icon(Icons.pie_chart),
      label: BudgetsScreen.title,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: appThemes[AppTheme.dark],
      theme: appThemes[AppTheme.light],
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appName),
          centerTitle: true,
          backgroundColor: const Color(0xFF2962FF),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings action
              },
            ),
          ],
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: _bottomNavBarItems,
        ),
      ),
    );
  }
}
