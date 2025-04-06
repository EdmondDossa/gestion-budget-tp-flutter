import 'package:flutter/material.dart';

import 'income.dart';
import 'income.repository.dart';

final class IncomeProvider with ChangeNotifier {
  final IncomeRepository _incomeRepository = IncomeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  final List<IncomeModel> _incomes = [];
  List<IncomeModel> get incomes => _incomes;

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
      final incomes = await _incomeRepository.findAll();
      _incomes.clear();
      _incomes.addAll(incomes);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(IncomeModel income) async {
    _setLoading(true);
    try {
      await _incomeRepository.create(income);
      final incomes = await _incomeRepository.findAll();
      _incomes.clear();
      _incomes.addAll(incomes);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> update(IncomeModel income) async {
    _setLoading(true);
    try {
      await _incomeRepository.update(income);
      final index = _incomes.indexWhere((inc) => inc.id == income.id);
      if (index != -1) {
        _incomes[index] = income;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> remove(IncomeModel income) async {
    _setLoading(true);
    try {
      await _incomeRepository.softDelete(income);
      _incomes.removeWhere((inc) => inc.id == income.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restore(IncomeModel income) async {
    _setLoading(true);
    try {
      await _incomeRepository.restore(income);
      final index = _incomes.indexWhere((inc) => inc.id == income.id);
      if (index != -1) {
        _incomes[index] = income;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> delete(IncomeModel income) async {
    _setLoading(true);
    try {
      await _incomeRepository.delete(income);
      _incomes.removeWhere((inc) => inc.id == income.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
