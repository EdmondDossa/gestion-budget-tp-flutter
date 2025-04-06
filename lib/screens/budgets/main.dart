import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetti/models/budget.dart';
import 'package:budgetti/models/budget.provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'widgets/budget_card.dart';
import 'widgets/budget_form.dart';

final class BudgetsScreen extends StatefulWidget {
  static const String title = 'Budgets';
  static const String routeName = '/budgets';

  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

final class _BudgetsScreenState extends State<BudgetsScreen> {
  BudgetModel? _budget;

  BudgetProvider get budgetProvider => Provider.of<BudgetProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      budgetProvider.fetchAll();
    });
  }

  void handleCreateBudget() {
    if (budgetProvider.budgets.length >= 4) {
      showShadDialog(
        context: context,
        builder: (context) => ShadDialog.alert(
          title: const Text('Maximum budget limit reached'),
          description: const Text('You can only create up to 4 budgets.'),
        ),
      );
      return;
    }

    setState(() {
      _budget = null;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: BudgetForm(
          budget: _budget,
          onSubmit: (budget) {
            budgetProvider.add(budget);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleEditBudget(BudgetModel budget) {
    setState(() {
      _budget = budget;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: BudgetForm(
          budget: _budget,
          onSubmit: (budget) {
            budgetProvider.update(budget);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleDeleteBudget(BudgetModel budget) {
    setState(() {
      _budget = budget;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Are you sure you want to delete this budget?'),
        description: Padding(
          padding: EdgeInsets.only(bottom: 8), 
          child: Text('This action is irreversible and will delete all associated transactions.'),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              budgetProvider.delete(budget);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(BudgetsScreen.title, style: theme.textTheme.h4), centerTitle: false),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<BudgetProvider>(
          builder: (context, budgetProvider, child) {
            if (budgetProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (budgetProvider.hasError) {
              return Center(
                child: Text(budgetProvider.error, style: theme.textTheme.h4),
              );
            }

            if (budgetProvider.budgets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage('assets/images/budgets_empty.png')),
                    const SizedBox(height: 16),
                    Text('No budgets available', style: theme.textTheme.h4),
                    const SizedBox(height: 8),
                    Text('Create a new budget to get started.', style: theme.textTheme.muted),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: budgetProvider.budgets.length,
              itemBuilder: (context, index) {
                final budget = budgetProvider.budgets[index];
                return BudgetCard(
                  budget: budget,
                  onEdit: () => handleEditBudget(budget),
                  onDelete: () => handleDeleteBudget(budget),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleCreateBudget(),
        tooltip: 'Create a budget',
        child: const Icon(Icons.add),
      ),
    );
  }
}
