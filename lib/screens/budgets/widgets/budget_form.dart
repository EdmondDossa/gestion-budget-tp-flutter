import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/budget.dart';

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

  bool get isEditMode => widget.budget?.id != null;

  late String? _id;
  late double _amount;
  late String _currencyCode;
  late BudgetPeriodicityEnum _periodicity;
  late String? _observation;
  late String _createdAt;
  late String? _updatedAt;

  @override
  void initState() {
    super.initState();
    _id = widget.budget?.id;
    _amount = widget.budget?.amount ?? 0.0;
    _currencyCode = widget.budget?.currencyCode ?? 'XOF';
    _periodicity = widget.budget?.periodicity ?? BudgetPeriodicityEnum.monthly;
    _observation = widget.budget?.observation ?? '';
    _createdAt = widget.budget?.createdAt.toString() ?? DateTime.now().toString();
    _updatedAt = widget.budget?.updatedAt?.toString();
  }

  void handleSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final budget = BudgetModel(
        id: _id,
        amount: _amount,
        currencyCode: _currencyCode,
        periodicity: _periodicity,
        observation: _observation,
        createdAt: DateTime.tryParse(_createdAt) ?? DateTime.now(),
        updatedAt: _updatedAt != null ? DateTime.tryParse(_updatedAt!) : null,
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
          const Text('Select the periodicity'),
          const SizedBox(height: 8),
          ShadSelect<BudgetPeriodicityEnum>(
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
                  onSaved: (value) => _amount = double.tryParse(value ?? '') ?? 0.0,
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
              ShadSelect<String>(
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