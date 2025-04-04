import 'package:budgetti/screens/categories/categories.screen.dart';
import 'package:budgetti/screens/dashboard/dashboard.screen.dart';
import 'package:budgetti/screens/expenses/expenses.screen.dart';
import 'package:budgetti/screens/incomes/incomes.screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExpensesScreen(),
    IncomesScreen(),
    CategoriesScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF2962FF),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 15,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            iconSize: 30,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.money_off),
                label: 'Dépenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Revenus',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Catégories',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
