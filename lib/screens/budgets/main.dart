import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '/models/budget.dart';
import '/models/budget.provider.dart';
import '/models/category.provider.dart';

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
  CategoryProvider get categoryProvider => Provider.of<CategoryProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      budgetProvider.fetchAll();
      categoryProvider.fetchAll();
    });
  }

  void handleCreateBudget() {
    if (categoryProvider.categories.isEmpty) {
      showShadDialog(
        context: context,
        builder: (context) => ShadDialog.alert(
          title: const Text('Aucune catégorie disponible'),
          description: const Text('Veuillez ajouter des catégories avant de créer un budget.'),
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
        title: const Text('Supprimer ce budget ?'),
        description: const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('Cette action est irréversible et supprimera toutes les transactions associées à ce budget.'),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ShadButton.destructive(
            onPressed: () {
              budgetProvider.delete(budget);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(BudgetsScreen.title, style: theme.textTheme.h4),
        centerTitle: false,
      ),
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
                    Text('Aucun budget disponible', style: theme.textTheme.h4),
                    const SizedBox(height: 8),
                    Text('Créez un nouveau budget pour commencer.', style: theme.textTheme.muted),
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
        onPressed: handleCreateBudget,
        tooltip: 'Créer un budget',
        child: const Icon(Icons.add),
      ),
    );
  }
}