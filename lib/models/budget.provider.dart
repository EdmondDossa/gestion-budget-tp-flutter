import 'package:flutter/material.dart';

import 'budget.dart';
import 'budget.repository.dart';

final class BudgetProvider with ChangeNotifier {

  final BudgetRepository _budgetRepository = BudgetRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  final List<BudgetModel> _budgets = [];
  List<BudgetModel> get budgets => _budgets;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

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
      await _budgetRepository.create(budget);
      _budgets.add(budget);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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