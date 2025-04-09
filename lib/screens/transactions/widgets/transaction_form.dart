import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '/models/transaction.dart';
import '/models/category.dart';
import '/models/category.provider.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? transaction;
  final Function(TransactionModel) onSubmit;

  const TransactionForm({
    super.key,
    this.transaction,
    required this.onSubmit,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  CategoryProvider get categoryProvider => Provider.of<CategoryProvider>(context, listen: false);

  bool get isEditMode => widget.transaction != null;

  late TransactionTypeEnum _type;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late String _currencyCode;
  late CategoryModel? _category;
  late DateTime _timestamp;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      categoryProvider.fetchAll();
    });

    _type = widget.transaction?.type ?? TransactionTypeEnum.expense;
    _titleController = TextEditingController(text: widget.transaction?.title ?? '');
    _descriptionController = TextEditingController(text: widget.transaction?.description ?? '');
    _amountController = TextEditingController(text: widget.transaction?.amount.toString() ?? '');
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
      final transaction = isEditMode
          ? TransactionModel.update(
              type: _type,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              category: _category,
              amount: double.parse(_amountController.text.trim()),
              currencyCode: _currencyCode,
              timestamp: _timestamp,
            )
          : TransactionModel.create(
              type: _type,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              category: _category,
              amount: double.parse(_amountController.text.trim()),
              currencyCode: _currencyCode,
              timestamp: _timestamp,
            );

      widget.onSubmit(transaction);
    }
  }

  Widget buildForm() {
    return Column(
      children: [
        ShadInputFormField(
          id: 'title',
          label: const Text('Intitulé'),
          controller: _titleController,
          validator: (value) => value.isEmpty ? 'L\'intitulé est requis' : null,
        ),
        const SizedBox(height: 8),
        ShadDatePickerFormField(
          id: 'timestamp',
          width: double.infinity,
          label: const Text('Date de la transaction'),
          initialValue: _timestamp,
          
          onChanged: (date) {
            if (date != null) {
              setState(() => _timestamp = date);
            }
          },
          validator: (date) => date == null ? 'Une date est requise.' : null,
        ),
        const SizedBox(height: 8),
        ShadSelectFormField<CategoryModel>(
          id: 'category',
          initialValue: _category,
          label: const Text('Catégorie'),
          minWidth: double.infinity,
          placeholder: const Text('Catégorie'),
          selectedOptionBuilder: (context, value) => Text(value.name),
          options: categoryProvider.categories.map((category) {
            return ShadOption(
              value: category,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _category = value;
            });
          },
          validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ShadInputFormField(
                id: 'amount',
                controller: _amountController,
                label: const Text('Montant'),
                keyboardType: TextInputType.number,
                placeholder: const Text('Montant de transaction'),
                validator: (value) {
                  if (value.isEmpty) return 'Le montant est requis';
                  if (double.tryParse(value.trim()) == null) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
            ),
            ShadSelectFormField<String>(
              id: 'currencyCode',
              initialValue: _currencyCode,
              placeholder: const Text('Devise'),
              selectedOptionBuilder: (context, value) => Text(value),
              options: ['XOF', 'USD', 'EUR']
                  .map((currency) => ShadOption(value: currency, child: Text(currency)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currencyCode = value);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadInputFormField(
          id: 'observation',
          maxLines: 5,
          label: const Text('Observation (optional)'),
          placeholder: const Text('Enter an observation'),
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadTabs<TransactionTypeEnum>(
              value: _type,
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
              tabs: [
                ShadTab(
                  value: TransactionTypeEnum.income,
                  content: ShadCard(
                    shadows: const [
                      BoxShadow(color: Colors.transparent, blurRadius: 0, offset: Offset(0, 0)),
                    ],
                    title: Text(isEditMode ? 'Éditer un revenu' : 'Ajouter un revenu'),
                    description: Text(isEditMode
                        ? 'Modifiez les informations de ce revenu.'
                        : 'Remplissez ce formulaire pour enregistrer un revenu.'),
                    child: buildForm(),
                  ),
                  child: const Text('Revenus'),
                ),
                ShadTab(
                  value: TransactionTypeEnum.expense,
                  content: ShadCard(
                    shadows: const [
                      BoxShadow(color: Colors.transparent, blurRadius: 0, offset: Offset(0, 0)),
                    ],
                    title: Text(isEditMode ? 'Éditer une dépense' : 'Ajouter une dépense'),
                    description: Text(isEditMode
                        ? 'Modifiez les informations de cette dépense.'
                        : 'Remplissez ce formulaire pour enregistrer une dépense.'),
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