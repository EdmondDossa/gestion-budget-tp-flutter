import 'package:flutter/material.dart';

import 'category.dart';
import 'category.repository.dart';

final class CategoryProvider with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _error = '';
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  Future<void> fetchAll() async {
    _setLoading(true);
    try {
      _categories = await _categoryRepository.findAll();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(CategoryModel category) async {
    _setLoading(true);
    try {
      await _categoryRepository.create(category);
      final categories = await _categoryRepository.findAll();
      _categories.clear();
      _categories.addAll(categories);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> update(CategoryModel category) async {
    _setLoading(true);
    try {
      await _categoryRepository.update(category);
      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> remove(CategoryModel category) async {
    _setLoading(true);
    try {
      await _categoryRepository.softDelete(category);
      _categories.removeWhere((cat) => cat.id == category.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restore(CategoryModel category) async {
    _setLoading(true);
    try {
      await _categoryRepository.restore(category);
      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> delete(CategoryModel category) async {
    _setLoading(true);
    try {
      await _categoryRepository.delete(category);
      _categories.removeWhere((cat) => cat.id == category.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
