import 'package:budgetti/models/budget.provider.dart';
import 'package:budgetti/models/category.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/categories/main.dart';
import 'screens/dashboard/main.dart';
import 'screens/expenses/main.dart';
import 'screens/budgets/main.dart';
import 'screens/incomes/main.dart';

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
  final List<Widget> _screens = const [
    DashboardMainScreen(),
    IncomesScreen(),
    ExpensesScreen(),
    CategoriesScreen(),
    BudgetsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: DashboardMainScreen.title,
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

  int _currentIndex = 0;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: appThemes[AppTheme.light],
        darkTheme: appThemes[AppTheme.dark],
        home: Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: _bottomNavBarItems,
          ),
        ),
      ),
    );
  }
}
