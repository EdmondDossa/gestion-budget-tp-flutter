import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetti/models/income.dart';
import 'package:budgetti/models/income.provider.dart';

import 'widgets/income_form.dart';
import 'widgets/income_card.dart';

final class IncomesScreen extends StatefulWidget {
  static const String title = 'Revenus';
  static const String routeName = '/incomes';

  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

final class _IncomesScreenState extends State<IncomesScreen> {
  IncomeModel? _income;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<IncomeProvider>(context, listen: false).fetchAll();
    });
  }

  void showIncomeForm() {
    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
      ),
      context: context,
      builder: (context) {
        return IncomeForm(
          income: _income,
          onSubmit: (income) {
            if (_income == null) {
              createIncome(income);
            } else {
              editIncome(income);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void createIncome(IncomeModel income) {
    final provider = Provider.of<IncomeProvider>(context, listen: false);
    provider.add(income);
  }

  void editIncome(IncomeModel income) {
    setState(() {
      _income = null;
    });
    final provider = Provider.of<IncomeProvider>(context, listen: false);
    provider.update(income);
  }

  void deleteIncome(IncomeModel income) {
    final provider = Provider.of<IncomeProvider>(context, listen: false);
    provider.remove(income);
  }

  Future<dynamic> showDeleteAlert(
    BuildContext context,
    IncomeModel income,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le revenu'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce revenu ?',
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.error,
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              onPressed: () {
                deleteIncome(income);
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(IncomesScreen.title)),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<IncomeProvider>(
          builder: (context, incomeProvider, child) {
            if (incomeProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (incomeProvider.hasError) {
              return Center(
                child: Text(
                  incomeProvider.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (incomeProvider.incomes.isEmpty) {
              return const Center(
                child: Text(
                  'Aucun revenu enregistré pour le moment.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: incomeProvider.incomes.length,
              itemBuilder: (context, index) {
                final income = incomeProvider.incomes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _income = income;
                    });
                    showIncomeForm();
                  },
                  child: IncomeCard(
                    income: income,
                    onDelete: () {
                      showDeleteAlert(context, income);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _income = null;
          });
          showIncomeForm();
        },
        tooltip: 'Ajouter un revenu',
        child: const Icon(Icons.add),
      ),
    );
  }
}
