import 'package:flutter/foundation.dart';

import 'package:budgetti/models/transaction.dart';
import 'package:budgetti/models/transaction.repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _error = '';

  // Getters
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get error => _error;

  // Fetch all transactions
  Future<void> fetchAll() async {
    _setLoading(true);

    try {
      final transactions = await _repository.findAll();
      _transactions = transactions;
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to load transactions: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Find transaction by ID
  Future<TransactionModel?> findById(String id) async {
    try {
      return await _repository.findById(id);
    } catch (e) {
      _setError(true, 'Failed to find transaction: ${e.toString()}');
      return null;
    }
  }

  // Add a new transaction
  Future<void> add(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.create(transaction);
      await fetchAll(); // Refresh the list
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to add transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing transaction
  Future<void> update(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.update(transaction);
      await fetchAll(); // Refresh the list
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to update transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Delete a transaction
  Future<void> delete(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.delete(transaction);
      await fetchAll(); // Refresh the list
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to delete transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Soft delete a transaction (mark as deleted)
  Future<void> softDelete(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.softDelete(transaction);
      await fetchAll(); // Refresh the list
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to soft delete transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Restore a soft-deleted transaction
  Future<void> restore(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.restore(transaction);
      await fetchAll(); // Refresh the list
      _setError(false, '');
    } catch (e) {
      _setError(true, 'Failed to restore transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Get transactions by type (income/expense)
  Future<List<TransactionModel>> getByType(TransactionTypeEnum type) async {
    try {
      return await _repository.findByType(type);
    } catch (e) {
      _setError(true, 'Failed to get transactions by type: ${e.toString()}');
      return [];
    }
  }

  // Get transactions in a date range
  Future<List<TransactionModel>> getByDateRange(DateTime start, DateTime end) async {
    try {
      return await _repository.findByDateRange(start, end);
    } catch (e) {
      _setError(true, 'Failed to get transactions by date range: ${e.toString()}');
      return [];
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool hasError, String message) {
    _hasError = hasError;
    _error = message;
    notifyListeners();
  }
}