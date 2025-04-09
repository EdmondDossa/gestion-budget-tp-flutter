import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '/models/budget.dart';
import '/models/category.dart';
import '/models/category.provider.dart';

final class BudgetForm extends StatefulWidget {
  final BudgetModel? budget;

  const BudgetForm({
    super.key,
    this.budget,
    required this.onSubmit,
  });

  final Function(BudgetModel budget) onSubmit;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<ShadFormState>();

  CategoryProvider get categoryProvider => Provider.of<CategoryProvider>(context, listen: false);

  bool get isEditMode => widget.budget?.id != null;

  late int? _id;
  late double _amount;
  late String _currencyCode;
  late BudgetPeriodicityEnum _periodicity;
  late String? _observation;
  late CategoryModel _category;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      categoryProvider.fetchAll();
    });

    _id = widget.budget?.id;
    _amount = widget.budget?.amount ?? 0;
    _currencyCode = widget.budget?.currencyCode ?? 'XOF';
    _periodicity = widget.budget?.periodicity ?? BudgetPeriodicityEnum.monthly;
    _observation = widget.budget?.observation ?? '';
    _category = widget.budget?.category ?? categoryProvider.categories.first;
  }

  void handleSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final budget = BudgetModel(
        id: _id,
        amount: _amount,
        currencyCode: _currencyCode,
        periodicity: _periodicity,
        observation: _observation,
        category: _category
      );
      widget.onSubmit(budget);
      handleReset();
    } else {
      print('Validation failed with ${_formKey.currentState!.value}');
    }
  }

  void handleReset() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditMode ? 'Edit Budget' : 'Create Budget',
            style: theme.textTheme.h4,
          ),
          const SizedBox(height: 8),
          Text(
            isEditMode ? 'Modify the budget details' : 'Enter the details for the new budget',
            style: theme.textTheme.muted,
          ),
          const SizedBox(height: 20),

          // Periodicity
          Text('Select the periodicity', style: theme.textTheme.small),
          const SizedBox(height: 8),
          ShadSelectFormField<BudgetPeriodicityEnum>(
            initialValue: _periodicity,
            minWidth: double.infinity,
            placeholder: const Text('Periodicity'),
            selectedOptionBuilder: (context, value) => Text(value.name),
            options: BudgetPeriodicityEnum.values.map((period) => ShadOption(value: period, child: Text(period.name))),
            onChanged: (value) {
              setState(() {
                _periodicity = value ?? BudgetPeriodicityEnum.monthly;
              });
            },
          ),
          const SizedBox(height: 20),

          // Category
          Text('Select the category', style: theme.textTheme.small),
          const SizedBox(height: 8),
          ShadSelectFormField<CategoryModel>(
            initialValue: _category,
            minWidth: double.infinity,
            placeholder: const Text('Category'),
            selectedOptionBuilder: (context, value) => Text(value.name),
            options: categoryProvider.categories.map((category) => ShadOption(value: category, child: Text(category.name))),
            onChanged: (value) {
              setState(() {
                _category = value ?? categoryProvider.categories.first;
              });
            },
          ),
          const SizedBox(height: 20),

          // Amount and Currency
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ShadInputFormField(
                  id: 'amount',
                  initialValue: _amount.toString(),
                  label: const Text('Amount'),
                  keyboardType: TextInputType.number,
                  placeholder: const Text('Enter the budget amount'),
                  onSaved: (value) => _amount = double.tryParse(value ?? '') ?? 0,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid amount';
                    }
                    return null;
                  },
                ),
              ),
              ShadSelectFormField<String>(
                initialValue: widget.budget?.currencyCode,
                placeholder: const Text('Currency'),
                selectedOptionBuilder: (context, value) => Text(value),
                options: ['XOF', 'USD', 'EUR'].map((currency) => ShadOption(value: currency, child: Text(currency))),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _currencyCode = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Observation
          ShadInputFormField(
            id: 'observation',
            initialValue: _observation,
            maxLines: 5,
            label: const Text('Observation (optional)'),
            placeholder: const Text('Enter an observation'),
            onSaved: (value) => _observation = value,
            validator: (value) {
              if (value.length > 100) {
                return 'Observation too long (max 100 characters)';
              }
              return null;
            },
          ),
          const SizedBox(height: 26),
          ShadButton(
            width: double.infinity,
            leading: const Icon(LucideIcons.save),
            onPressed: handleSubmit,
            child: Text(isEditMode ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }
}