import 'package:budgetti/models/category.dart';
import 'package:flutter/material.dart';

final class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, this.onDelete});

  final CategoryModel category;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
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
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Description: ${category.description ?? "Pas de description"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onDelete!(),
              child: Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
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
