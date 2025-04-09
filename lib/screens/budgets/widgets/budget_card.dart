import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/budget.dart';

final class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.budget, this.onEdit, this.onDelete});

  final BudgetModel budget;
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
                  Text('${budget.periodicity.name} Budget', style: theme.textTheme.h3),
                  const SizedBox(height: 4),
                  Text('Category: ${budget.category.name}', style: theme.textTheme.muted),
                  const SizedBox(height: 4),
                  Text('Amount: ${budget.amount} ${budget.currencyCode}', style: theme.textTheme.muted),
                  const SizedBox(height: 4),
                  Text('Observation: ${budget.observation ?? 'No observations'}', style: theme.textTheme.muted),
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