import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:budgetti/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    // Format currency display
    final formattedAmount = '${transaction.currencyCode} ${transaction.amount.toStringAsFixed(2)}';
    
    // Format date display
    final day = transaction.timestamp.day.toString().padLeft(2, '0');
    final month = transaction.timestamp.month.toString().padLeft(2, '0');
    final year = transaction.timestamp.year.toString();
    final formattedDate = '$day/$month/$year';

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: theme.textTheme.h4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (transaction.description != null && transaction.description!.isNotEmpty)
                        Text(
                          transaction.description!,
                          style: theme.textTheme.muted,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Transaction type badge
                          // ShadBadge(variant: transaction.type == TransactionTypeEnum.income ? ShadBadgeVariant.outline : ShadBadgeVariant.destructive, child: Text(transaction.type.name)),
                          const SizedBox(width: 8),
                          // Date indicator
                          Row(children: [
                              Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.mutedForeground),
                              const SizedBox(width: 4),
                              Text(formattedDate, style: theme.textTheme.muted),
                            ]),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side - Amount and actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedAmount,
                      style: theme.textTheme.h4.copyWith(
                        color: transaction.type == TransactionTypeEnum.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 18),
                          onPressed: onEdit,
                          tooltip: 'Edit transaction',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, size: 18),
                          onPressed: onDelete,
                          tooltip: 'Delete transaction',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            // Display category if available
            if (transaction.category != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 14,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      transaction.category!.name,
                      style: theme.textTheme.muted,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}