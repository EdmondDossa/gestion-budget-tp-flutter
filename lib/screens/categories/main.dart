import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<CategoryProvider>(context, listen: false).fetchAll();
    });
  }

  void showCategoryForm() {
    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
      ),
      context: context,
      builder: (context) {
        return CategoryForm(
          category: _category,
          onSubmit: (categroy) {
            if (_category == null) {
              createCategory(categroy);
            } else {
              editCategory(categroy);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  CategoryModel? _category;

  void createCategory(CategoryModel category) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.add(category);
  }

  void editCategory(CategoryModel category) {
    setState(() {
      _category = null;
    });
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.update(category);
  }

  void deleteCategory(CategoryModel category) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.remove(category);
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> ShowDeleteAlert(
    BuildContext context,
    CategoryModel category,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la catégorie'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer la catégorie ?',
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.error,
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              onPressed: () {
                deleteCategory(category);
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(CategoriesScreen.title)),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (categoryProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoryProvider.hasError) {
              return Center(
                child: Text(
                  categoryProvider.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (categoryProvider.categories.isEmpty) {
              return const Center(
                child: Text(
                  'Pas de catégories précédemment créées',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _category = category;
                    });
                    showCategoryForm();
                  },
                  child: CategoryCard(
                    category: category,
                    onDelete: () {
                      ShowDeleteAlert(context, category);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _category = null;
          });
          showCategoryForm();
        },
        tooltip: 'Créer une catégorie',
        child: const Icon(Icons.add),
      ),
    );
  }
}
