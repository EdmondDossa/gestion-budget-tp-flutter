import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/category.dart';
import 'package:budgetti/models/category.provider.dart';

import 'widgets/category_form.dart';
import 'widgets/category_card.dart';

final class CategoriesScreen extends StatefulWidget {
  static const String title = 'Catégories';
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

final class _CategoriesScreenState extends State<CategoriesScreen> {
  
  CategoryModel? _category;

  CategoryProvider get categoryProvider => Provider.of<CategoryProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      categoryProvider.fetchAll();
    });
  }

  void handleCreateCategory() {
    setState(() {
      _category = null;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: CategoryForm(
          category: _category,
          onSubmit: (category) {
            categoryProvider.add(category);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleEditCategory(CategoryModel category) {
    setState(() {
      _category = category;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        padding: const EdgeInsets.all(16),
        child: CategoryForm(
          category: _category,
          onSubmit: (category) {
            categoryProvider.update(category);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void handleDeleteCategory(CategoryModel category) {
    setState(() {
      _category = category;
    });

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Êtes-vous sûr de vouloir supprimer cette catégorie ?'),
        description: Padding(
          padding: EdgeInsets.only(bottom: 8), 
          child: Text('Cette action est irréversible et supprimera toutes les transactions associées à cette catégorie.')
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ShadButton.destructive(
            onPressed: () {
              categoryProvider.delete(category);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(CategoriesScreen.title, style: theme.textTheme.h4), centerTitle: false,),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (categoryProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoryProvider.hasError) {
              return Center(
                child: Text(categoryProvider.error, style: theme.textTheme.h4),
              );
            }

            if (categoryProvider.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage('assets/images/categories_empty.png')),
                    const SizedBox(height: 16),
                    Text('Aucune catégorie disponible', style: theme.textTheme.h4),
                    const SizedBox(height: 8),
                    Text('Créez une nouvelle catégorie pour commencer.', style: theme.textTheme.muted),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return CategoryCard(
                  category: category,
                  onEdit: () => handleEditCategory(category),
                  onDelete: () => handleDeleteCategory(category),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleCreateCategory(),
        tooltip: 'Créer une catégorie',
        child: const Icon(Icons.add),
      ),
    );
  }
}
