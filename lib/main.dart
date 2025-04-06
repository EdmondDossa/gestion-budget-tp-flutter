import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'screens/categories/main.dart';
import 'screens/dashboard/main.dart';
import 'screens/transactions/main.dart';
import 'screens/budgets/main.dart';

import 'models/budget.provider.dart';
import 'models/category.provider.dart'; 
import 'models/transaction.provider.dart';

import 'app/themes.dart';
import 'app/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
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
      icon: Icon(Icons.currency_exchange_outlined),
      activeIcon: Icon(Icons.currency_exchange),
      label: TransactionsScreen.title,
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
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: ShadApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: appThemes[AppTheme.light],
        home: Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: ShadSlateColorScheme.light().muted,
            unselectedFontSize: 12,
            selectedFontSize: 12,
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: _bottomNavBarItems,
          ),
        ),
      ),
    );
  }
}
