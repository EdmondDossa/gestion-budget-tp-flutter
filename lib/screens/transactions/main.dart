import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/transaction.dart';
import 'package:budgetti/models/transaction.provider.dart';
import 'widgets/transaction_card.dart';
import 'widgets/transaction_form.dart';

final class TransactionsScreen extends StatefulWidget {
  static const String title = 'Transactions';
  static const String routeName = '/transactions';

  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

final class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionModel? _transaction;

  TransactionProvider get transactionProvider => Provider.of<TransactionProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      transactionProvider.fetchAll();
    });
  }

  void handleCreateTransaction() {
    setState(() {
      _transaction = null;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: TransactionForm(
          transaction: _transaction,
          onSubmit: (transaction) {
            transactionProvider.add(transaction);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleEditTransaction(TransactionModel transaction) {
    setState(() {
      _transaction = transaction;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: TransactionForm(
          transaction: _transaction,
          onSubmit: (transaction) {
            transactionProvider.update(transaction);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleDeleteTransaction(TransactionModel transaction) {
    setState(() {
      _transaction = transaction;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Are you sure you want to delete this transaction?'),
        description: const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('This action is irreversible.'),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              transactionProvider.delete(transaction);
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
      appBar: AppBar(title: Text(TransactionsScreen.title, style: theme.textTheme.h4), centerTitle: false),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            if (transactionProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (transactionProvider.hasError) {
              return Center(
                child: Text(transactionProvider.error, style: theme.textTheme.h4),
              );
            }

            if (transactionProvider.transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage('assets/images/transactions_empty.png')),
                    const SizedBox(height: 16),
                    Text('No transactions available', style: theme.textTheme.h4),
                    const SizedBox(height: 8),
                    Text('Create a new transaction to get started.', style: theme.textTheme.muted),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionProvider.transactions[index];
                return TransactionCard(
                  transaction: transaction,
                  onEdit: () => handleEditTransaction(transaction),
                  onDelete: () => handleDeleteTransaction(transaction),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleCreateTransaction(),
        tooltip: 'Create a transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
