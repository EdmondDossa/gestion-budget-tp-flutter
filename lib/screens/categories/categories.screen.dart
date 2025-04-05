import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {

  static const String title = 'Categories';
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const Center(
        child: Text('Categories Screen'),
      ),
    );
  }
}