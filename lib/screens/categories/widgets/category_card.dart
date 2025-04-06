import 'package:budgetti/models/category.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, this.onEdit, this.onDelete});

  final CategoryModel category;
  final Function? onEdit;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: theme.radius,
          border: Border.all(color: theme.colorScheme.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: theme.textTheme.small),
                  const SizedBox(height: 4),
                  Text(category.description ?? 'Pas de description', style: theme.textTheme.muted),
                ],
              ),
            ),
            ShadIconButton(
              icon: const Icon(LucideIcons.pen),
              onPressed: () => onEdit!(),
            ),
            ShadIconButton.destructive(
              icon: const Icon(LucideIcons.trash),
              onPressed: () => onDelete!(),
            ),
          ],
        ),
      ),
    );
  }
}
