import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/category.dart';

final class CategoryForm extends StatefulWidget {
  final CategoryModel? category;

  const CategoryForm({
    super.key,
    this.category,
    required this.onSubmit
  });

  final Function(CategoryModel category) onSubmit;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<ShadFormState>();

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
    _createdAt = widget.category?.createdAt.toString() ?? DateTime.now().toString();
    _updatedAt = widget.category?.updatedAt?.toString();
    _deletedAt = widget.category?.deletedAt?.toString();
  }

  void handleSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final category = CategoryModel(
        id: _id,
        name: _name,
        description: _description,
        createdAt: DateTime.tryParse(_createdAt) ?? DateTime.now(),
        updatedAt: _updatedAt != null ? DateTime.tryParse(_updatedAt!) : null,
        deletedAt: _deletedAt != null ? DateTime.tryParse(_deletedAt!) : null,
      );
      widget.onSubmit(category);

      handleReset();
    } else {
      print('validation failed with ${_formKey.currentState!.value}');
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
            isEditMode ? 'Modifier la Catégorie' : 'Créer une Catégorie',
            style: theme.textTheme.h4,
          ),
          const SizedBox(height: 8),
          Text(
            isEditMode ? 'Modifiez les informations de la catégorie' : 'Entrez les informations de la nouvelle catégorie',
            style: theme.textTheme.muted,
          ),
          const SizedBox(height: 20),
          ShadInputFormField(
            id: 'name',
            initialValue: _name,
            label: const Text('Nom de la Catégorie'),
            placeholder: const Text('Entrez le nom de la Catégorie'),
            description: const Text('Ex: Alimentation, Transport, etc.'),
            onSaved: (value) => _name = value ?? '',
            validator: (value) {
              if (value.isEmpty) {
                return 'Nom de la Catégorie requis';
              }
              if (value.length > 50) {
                return 'Nom trop long (max 50 caractères)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ShadInputFormField(
            id: 'description',
            initialValue: _description,
            label: const Text('Description (optional)'),
            placeholder: const Text('Entrez une description'),
            description: const Text('Ex: Catégorie pour les dépenses alimentaires'),
            onSaved: (value) => _description = value,
            validator: (value) {
              if (value.length > 100) {
                return 'Description trop longue (max 100 caractères)';
              }
              return null;
            },
          ),
          const SizedBox(height: 26),
          ShadButton(
            width: double.infinity,
            leading: const Icon(LucideIcons.save),
            onPressed: handleSubmit,
            child: Text(isEditMode ? 'Modifier' : 'Enregistrer'),
            ),
        ],
      ),
    );
  }
}
