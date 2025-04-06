import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/category.dart';
import 'package:budgetti/models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? transaction;
  final Function(TransactionModel) onSubmit;

  const TransactionForm({super.key, this.transaction, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  late TransactionTypeEnum _type;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late String _currencyCode;
  late CategoryModel? _category;
  late DateTime _timestamp;

  bool get isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    _type = widget.transaction?.type ?? TransactionTypeEnum.expense;
    _titleController = TextEditingController(
      text: widget.transaction?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _currencyCode = widget.transaction?.currencyCode ?? 'XOF';
    _category = widget.transaction?.category;
    _timestamp = widget.transaction?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final transaction =
          isEditMode
              ? TransactionModel.update(
                id: widget.transaction!.id,
                type: _type,
                title: _titleController.text,
                description: _descriptionController.text,
                category: _category,
                amount: double.parse(_amountController.text),
                currencyCode: _currencyCode,
                timestamp: _timestamp,
                createdAt: widget.transaction!.createdAt,
                updatedAt: DateTime.now(),
              )
              : TransactionModel.create(
                type: _type,
                title: _titleController.text,
                description: _descriptionController.text,
                category: _category,
                amount: double.parse(_amountController.text),
                currencyCode: _currencyCode,
                timestamp: _timestamp,
                createdAt: DateTime.now(),
              );

      widget.onSubmit(transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadTabs<TransactionTypeEnum>(
              value: _type,
              tabBarConstraints: const BoxConstraints(maxWidth: 400),
              contentConstraints: const BoxConstraints(maxWidth: 400),
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
              tabs: [
                ShadTab(
                  value: TransactionTypeEnum.income,
                  content: ShadCard(
                    title: Text(isEditMode ? 'Éditer le revenue' : 'Enregistrer un revenue'),
                    description: Text(isEditMode ? 'Éditer le revenue ${widget.transaction?.title}': 'Remplisser le formulaire pour enregistrer un revenue'),
                    footer: ShadButton(child: Text(isEditMode ? 'Sauvegarder' : 'Enregistrer')),
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
                  value: TransactionTypeEnum.expense,
                  content: ShadCard(
                    title: Text(isEditMode ? 'Éditer le dépense' : 'Enregistrer un dépense'),
                    description: Text(isEditMode ? 'Éditer le dépense ${widget.transaction?.title}': 'Remplisser le formulaire pour enregistrer un dépense'),
                    footer: ShadButton(child: Text(isEditMode ? 'Sauvegarder' : 'Enregistrer')),
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
          ],
        ),
      ),
    );
  }
}
