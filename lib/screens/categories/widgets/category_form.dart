import 'package:budgetti/models/category.dart';
import 'package:flutter/material.dart';

final class CategoryForm extends StatefulWidget {
  final CategoryModel? category;

  const CategoryForm({super.key, this.category, required this.onSubmit});

  final Function(CategoryModel category) onSubmit;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  bool get isEditMode => widget.category?.id != null;

  late String _name;
  late String? _description;
  late String? _id;
  late String _createdAt;
  late String? _updatedAt;
  late String? _deletedAt;

  @override
  void initState() {
    super.initState();
    _id = widget.category?.id;
    _name = widget.category?.name ?? '';
    _description = widget.category?.description ?? '';
    _createdAt =
        widget.category?.createdAt.toString() ?? DateTime.now().toString();
    _updatedAt = widget.category?.updatedAt?.toString();
    _deletedAt = widget.category?.deletedAt?.toString();
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
              widget.category?.id != null
                  ? 'Modifier la Categorie'
                  : 'Créer une Categorie',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(
                labelText: 'Nom de la Categorie',
                hintText: 'Entrez le nom de la Categorie',
                helperText: 'Ex: Alimentation, Transport, etc.',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _name = value ?? '',
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'Entrez le nom de la Categorie'
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
                          ? 'Description trop longue (max 100 caractères)'
                          : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  isEditMode ? 'Modifier la catégorie' : 'Créer une catégorie',
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final category = CategoryModel(
                      id: _id,
                      name: _name,
                      description: _description,
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
                    widget.onSubmit(category);
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
