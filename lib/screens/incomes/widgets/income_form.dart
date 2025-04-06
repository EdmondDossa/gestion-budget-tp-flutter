import 'package:flutter/material.dart';
import 'income.dart';
import 'package:intl/intl.dart';

final class IncomeForm extends StatefulWidget {
  final IncomeModel? income;
  final Function(IncomeModel income) onSubmit;

  const IncomeForm({
    super.key,
    this.income,
    required this.onSubmit,
  });

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();

  late String _label;
  late double _amount;
  late String? _observation;
  late DateTime _date;
  late String _createdAt;
  late String? _updatedAt;
  late String? _deletedAt;


  bool get isEditMode => widget.income != null;

  @override
  void initState() {
    super.initState();
    _label = widget.income?.label ?? '';
    _amount = widget.income?.amount ?? 0.0;
    _observation = widget.income?.observation ?? '';
    _date = widget.income?.date ?? DateTime.now();
    _createdAt =
        widget.income?.createdAt.toString() ?? DateTime.now().toString();
    _updatedAt = widget.income?.updatedAt?.toString();
    _deletedAt = widget.income?.deletedAt?.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd('fr_FR').format(_date);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditMode ? 'Modifier le revenu' : 'Ajouter un revenu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Champ label
            TextFormField(
              initialValue: _label,
              decoration: const InputDecoration(
                labelText: 'Libellé du revenu',
                hintText: 'Ex: Salaire, Freelance...',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _label = value ?? '',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Entrez un libellé' : null,
            ),

            const SizedBox(height: 16),

            // Champ montant
            TextFormField(
              initialValue: _amount.toString(),
              decoration: const InputDecoration(
                labelText: 'Montant (FCFA)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) =>
                  _amount = double.tryParse(value ?? '0') ?? 0.0,
              validator: (value) {
                final amount = double.tryParse(value ?? '');
                if (amount == null || amount <= 0) {
                  return 'Entrez un montant valide';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Champ observation
            TextFormField(
              initialValue: _observation,
              decoration: const InputDecoration(
                labelText: 'Observation (facultatif)',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _observation = value,
              validator: (value) => (value != null && value.length > 100)
                  ? 'Observation trop longue (max 100 caractères)'
                  : null,
            ),

            const SizedBox(height: 16),

            // Sélecteur de date
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date : $formattedDate',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Choisir'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bouton Enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  isEditMode ? 'Modifier le revenu' : 'Ajouter le revenu',
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final income = IncomeModel(
                      id: widget.income?.id,
                      label: _label,
                      amount: _amount,
                      observation: _observation,
                      date: _date,
                      createdAt:
                          DateTime.tryParse(_createdAt) ?? DateTime.now(),
                      updatedAt:
                          _updatedAt != null
                              ? DateTime.tryParse(_updatedAt!)
                              : null,
                      deletedAt:
                          _deletedAt != null
                              ? DateTime.tryParse(_deletedAt!)
                              : null,
                    );
                    widget.onSubmit(income);
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
