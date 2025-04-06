import 'package:budgetti/models/category.repository.dart';
import 'package:flutter/material.dart';
import 'package:budgetti/models/category.dart';
import 'package:budgetti/models/transaction.dart';

class IncomeForm extends StatefulWidget {
  final TransactionModel? transaction;

  const IncomeForm({super.key, this.transaction, required this.onSubmit});

  final Function(
    String title,
    String? description,
    double amount,
    CategoryModel category,
    TransactionTypeEnum type,
  )
  onSubmit;

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();

  bool get isEditMode => widget.transaction != null;

  late String _title;
  late String? _description;
  late double _amount;
  late CategoryModel? _category;
  late TransactionTypeEnum _type;

  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _title = widget.transaction?.title ?? '';
    _description = widget.transaction?.description ?? '';
    _amount = widget.transaction?.amount ?? 0.0;
    _category = widget.transaction?.category;
    _type = widget.transaction?.type ?? TransactionTypeEnum.income;
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await CategoryRepository().findAll();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching categories: $e');
    }
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
              isEditMode ? 'Edit Income' : 'Create Income',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _title = value ?? '',
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please enter a title'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _description = value,
              validator:
                  (value) =>
                      value != null && value.length > 100
                          ? 'Description must be less than 100 characters'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _amount == 0.0 ? '' : _amount.toString(),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
            _isLoading
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<CategoryModel>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _categories.map((category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                  onSaved: (value) {
                    if (value != null) _category = value;
                  },
                  validator:
                      (value) =>
                          (value == null) ? 'Please select a category' : null,
                ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditMode ? 'Update Income' : 'Create Income'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (_category != null) {
                      widget.onSubmit(
                        _title,
                        _description,
                        _amount,
                        _category!,
                        _type,
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
