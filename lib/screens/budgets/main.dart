import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetti/models/budget.dart';
import 'package:budgetti/models/budget.provider.dart';

import 'widgets/budget_form.dart';
import 'widgets/budget_card.dart';

final class BudgetsScreen extends StatefulWidget {

  static const String title = 'Budgets';
  static const String routeName = '/budgets';

  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

final class _BudgetsScreenState extends State<BudgetsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<BudgetProvider>(context, listen: false).fetchAll());
  }

  void showBudgetForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BudgetForm(
          onSubmit: (name, description, amount, periodicity) {
            final budget = BudgetModel.create(
              name: name,
              description: description,
              periodicity: periodicity,
              amount: amount,
              currencyCode: 'XOF'
            );
            createBudget(budget);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void createBudget(BudgetModel budget) {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    budgetProvider.add(budget);
  }

  void editBudget(BudgetModel budget) {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    budgetProvider.update(budget);
  }

  void deleteBudget(BudgetModel budget) {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    budgetProvider.remove(budget);
  }

  @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: const Text(BudgetsScreen.title),
        ),
        body: Consumer<BudgetProvider>(builder: (context, budgetProvider, child) {
          if (budgetProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (budgetProvider.hasError) {
            return Center(
              child: Text(
                budgetProvider.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (budgetProvider.budgets.isEmpty) {
            return const Center(
              child: Text(
                'No budgets available',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: budgetProvider.budgets.length,
            itemBuilder: (context, index) {
              final budget = budgetProvider.budgets[index];
              return GestureDetector(
                onTap: () => editBudget(budget),
                child: BudgetCard(budget: budget),
              );
            }
          );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showBudgetForm,
          tooltip: 'Create a new budget',
          child: const Icon(Icons.add),
        ),
    );
  }
}