import 'package:flutter/material.dart';

import 'transaction.dart';
import 'category.dart';
import 'currency.dart';
import 'transaction.repository.dart';

final class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository = TransactionRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

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
      final transactions = await _transactionRepository.findAll();
      _transactions.clear();
      _transactions.addAll(transactions);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(TransactionModel transaction) async {
    _setLoading(true);
    try {
      await _transactionRepository.create(transaction);
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> update(TransactionModel transaction) async {
    _setLoading(true);
    try {
      await _transactionRepository.update(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> delete(TransactionModel transaction) async {
    _setLoading(true);
    try {
      await _transactionRepository.delete(transaction);
      _transactions.removeWhere((t) => t.id == transaction.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> softDelete(TransactionModel transaction) async {
    _setLoading(true);
    try {
      await _transactionRepository.softDelete(transaction);
      _transactions.removeWhere((t) => t.id == transaction.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> restore(TransactionModel transaction) async {
    _setLoading(true);
    try {
      await _transactionRepository.restore(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> findByType(TransactionTypeEnum type) async {
    _setLoading(true);
    try {
      final transactions = await _transactionRepository.findByType(type);
      _transactions.clear();
      _transactions.addAll(transactions);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> findByCategory(CategoryModel category) async {
    _setLoading(true);
    try {
      final transactions = await _transactionRepository.findByCategory(
        category,
      );
      _transactions.clear();
      _transactions.addAll(transactions);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> findByDateRange(DateTime startDate, DateTime endDate) async {
    _setLoading(true);
    try {
      final transactions = await _transactionRepository.findByDateRange(
        startDate,
        endDate,
      );
      _transactions.clear();
      _transactions.addAll(transactions);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> findByCurrency(CurrencyModel currency) async {
    _setLoading(true);
    try {
      final transactions = await _transactionRepository.findByCurrency(
        currency,
      );
      _transactions.clear();
      _transactions.addAll(transactions);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
