import 'package:flutter/material.dart';

import 'package:budgetti/models/budget.dart';

final class BudgetForm extends StatefulWidget {
  final BudgetModel? budget;

  const BudgetForm({
    super.key,
    this.budget,
    required this.onSubmit,
  });

  final Function(String name, String? description, double amount, BudgetPeriodicityEnum periodicity) onSubmit;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();

  bool get isEditMode => widget.budget != null;

  late String _name;
  late String? _description;
  late double _amount;
  late BudgetPeriodicityEnum _periodicity;

  @override
  void initState() {
    super.initState();
    _name = widget.budget?.name ?? '';
    _description = widget.budget?.description ?? '';
    _amount = widget.budget?.amount ?? 0.0;
    _periodicity = widget.budget?.periodicity ?? BudgetPeriodicityEnum.monthly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditMode ? 'Edit Budget' : 'Create Budget',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _name = value ?? '',
              validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _description = value,
              validator: (value) => value != null && value.length > 100 ? 'Description must be less than 100 characters' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _amount == 0.0 ? '' : _amount.toString(),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSaved: (value) => _amount = double.tryParse(value ?? '') ?? 0.0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BudgetPeriodicityEnum>(
              value: _periodicity,
              decoration: const InputDecoration(
                labelText: 'Periodicity',
                border: OutlineInputBorder(),
              ),
              items: BudgetPeriodicityEnum.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(period.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _periodicity = value);
                }
              },
              onSaved: (value) {
                if (value != null) _periodicity = value;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditMode ? 'Update Budget' : 'Create Budget'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    widget.onSubmit(_name, _description, _amount, _periodicity);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}