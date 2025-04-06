import 'package:flutter/material.dart';
import 'income.dart';
import 'package:intl/intl.dart';

final class IncomeCard extends StatelessWidget {
  const IncomeCard({super.key, required this.income, this.onDelete});

  final IncomeModel income;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd('fr_FR').format(income.date);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    income.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Montant : ${income.amount.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date : $formattedDate',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Observation : ${income.observation?.isNotEmpty == true ? income.observation : "Aucune"}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              GestureDetector(
                onTap: () => onDelete!(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
