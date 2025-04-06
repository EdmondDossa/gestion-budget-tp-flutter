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

  Widget buildForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ShadInputFormField(
          label: const Text('Titre'),
          controller: _titleController,
          validator: (value) => value.isEmpty ? 'Le titre est requis' : null,
        ),
        const SizedBox(height: 8),
        ShadInputFormField(
          label: const Text('Montant'),
          controller: _amountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Entrez un montant valide';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        ShadInputFormField(
          label: const Text('Description'),
          controller: _descriptionController,
        ),
        const SizedBox(height: 16),
        ShadButton(
          width: double.infinity,
          onPressed: _handleSubmit,
          child: Text(isEditMode ? 'Mettre à jour' : 'Enregistrer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadTabs<TransactionTypeEnum>(
              value: _type,
              onChanged: (value) {
                setState(() => _type = value);
              },
              tabBarConstraints: const BoxConstraints(maxWidth: 400),
              contentConstraints: const BoxConstraints(maxWidth: 400),
              tabs: [
                ShadTab(
                  value: TransactionTypeEnum.income,
                  content: ShadCard(
                    border: Border.all(width: 0, color: Colors.transparent),
                    shadows: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    title: Text(
                      isEditMode ? 'Éditer un revenu' : 'Ajouter un revenu',
                    ),
                    description: Text(
                      isEditMode
                          ? 'Modifiez les informations de ce revenu.'
                          : 'Remplissez ce formulaire pour enregistrer un revenu.',
                    ),
                    footer: const SizedBox.shrink(),
                    child: buildForm(),
                  ),
                  child: const Text('Revenus'),
                ),
                ShadTab(
                  value: TransactionTypeEnum.expense,
                  content: ShadCard(
                    border: Border.all(width: 0, color: Colors.transparent),
                    shadows: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    title: Text(
                      isEditMode ? 'Éditer une dépense' : 'Ajouter une dépense',
                    ),
                    description: Text(
                      isEditMode
                          ? 'Modifiez les informations de cette dépense.'
                          : 'Remplissez ce formulaire pour enregistrer une dépense.',
                    ),
                    footer: const SizedBox.shrink(),
                    child: buildForm(),
                  ),
                  child: const Text('Dépenses'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
