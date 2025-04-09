import 'package:flutter/material.dart';

import 'budget.dart';
import 'budget.repository.dart';

final class BudgetProvider with ChangeNotifier {
  final BudgetRepository _budgetRepository = BudgetRepository();

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

  final List<BudgetModel> _budgets = [];
  List<BudgetModel> get budgets => _budgets;

  Future<void> fetchAll() async {
    _setLoading(true);
    try {
      final budgets = await _budgetRepository.findAll();
      _budgets.clear();
      _budgets.addAll(budgets);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(BudgetModel budget) async {
    _setLoading(true);
    try {
      final int result = await _budgetRepository.create(budget);
      if (result == 0) {
        _setError('Failed to create budget.');
        return;
      }
      _budgets.add(budget);
      notifyListeners();
    } on Exception catch (e) {
      if (e.toString().contains('periodicity')) {
        _setError('A budget with this periodicity already exists.');
      } else {
        _setError('Something went wrong.');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> update(BudgetModel budget) async {
    _setLoading(true);
    try {
      await _budgetRepository.update(budget);
      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> remove(BudgetModel budget) async {
    _setLoading(true);
    try {
      await _budgetRepository.softDelete(budget);
      _budgets.removeWhere((b) => b.id == budget.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restore(BudgetModel budget) async {
    _setLoading(true);
    try {
      await _budgetRepository.restore(budget);
      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> delete(BudgetModel budget) async {
    _setLoading(true);
    try {
      await _budgetRepository.delete(budget);
      _budgets.removeWhere((b) => b.id == budget.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
