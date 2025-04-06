import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardMainScreen extends StatelessWidget {
  static const String title = 'Dashboard';
  static const String routeName = '/dashboard';

  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: ShadTabs<String>(
            value: 'incomes',
            tabBarConstraints: const BoxConstraints(maxWidth: 400),
            contentConstraints: const BoxConstraints(maxWidth: 400),
            tabs: [
              ShadTab(
                value: 'incomes',
                content: ShadCard(
                  title: const Text('Incomes'),
                  description: const Text(
                    "Manage your income sources here. Click save when you're done.",
                  ),
                  footer: const ShadButton(child: Text('Save changes')),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        label: const Text('Name'),
                        initialValue: 'Ale',
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        label: const Text('Username'),
                        initialValue: 'nank1ro',
                      ),
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        label: const Text('Amount'),
                        initialValue: '0',
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        label: const Text('Description'),
                        initialValue: '',
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        label: const Text('New Field'),
                        initialValue: '',
                      ),
                    ],
                  ),
                ),
                child: const Text('Incomes'),
              ),
              ShadTab(
                value: 'expenses',
                content: ShadCard(
                  title: const Text('Expenses'),
                  description: const Text(
                    "Manage your expenses here. Click save when you're done.",
                  ),
                  footer: const ShadButton(child: Text('Save expenses')),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        label: const Text('Current expenses'),
                        obscureText: false,
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        label: const Text('New expenses'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                child: const Text('Expenses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
