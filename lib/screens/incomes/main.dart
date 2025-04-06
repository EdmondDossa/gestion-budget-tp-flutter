import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetti/models/transaction.dart';
import 'package:budgetti/models/transaction.provider.dart';

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
  @override
  void initState() {
    super.initState();
    // Fetch expenses when the screen is initialized
    Future.microtask(() => Provider.of<TransactionProvider>(context, listen: false)
        .findByType(TransactionTypeEnum.income));
  }

  void showTransactionForm({TransactionModel? transaction}) {
    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return IncomeForm(
          transaction: transaction,
          onSubmit: (title, description, amount, category, type) {
            final newTransaction = TransactionModel(
              id: transaction?.id ?? UniqueKey().toString(),
              type: type,
              title: title,
              description: description,
              amount: amount,
              category: category,
              currencyCode: 'XOF',
              createdAt: transaction?.createdAt ?? DateTime.now(),
              timestamp: DateTime.now(),
            );

            if (transaction == null) {
              createTransaction(newTransaction);
            } else {
              editTransaction(newTransaction);
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void createTransaction(TransactionModel transaction) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.add(transaction);
  }

  void editTransaction(TransactionModel transaction) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.update(transaction);
  }

  void deleteTransaction(TransactionModel transaction) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.delete(transaction);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text(IncomesScreen.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showTransactionForm(),
          ),
        ],
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('Aucune dépense trouvée'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return IncomeCard(
                  transaction: transaction,
                  onEdit: () => showTransactionForm(transaction: transaction),
                  onDelete: () => deleteTransaction(transaction),
                );
              },
            ),
    );
  }
}