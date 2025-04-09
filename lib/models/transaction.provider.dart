import 'package:flutter/foundation.dart';

import 'transaction.dart';
import 'transaction.repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

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

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  // Fetch all transactions
  Future<void> fetchAll() async {
    _setLoading(true);

    try {
      _transactions = await _repository.findAll();
    } catch (e) {
      _setError('Failed to load transactions: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Find transaction by ID
  Future<TransactionModel?> findById(int id) async {
    _setLoading(true);

    try {
      return await _repository.findById(id);
    } catch (e) {
      _setError('Failed to find transaction: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Add a new transaction
  Future<void> add(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.create(transaction);
      await fetchAll();
    } catch (e) {
      _setError('Failed to add transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing transaction
  Future<void> update(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.update(transaction);
      await fetchAll();
    } catch (e) {
      _setError('Failed to update transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Delete a transaction
  Future<void> delete(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.delete(transaction);
      await fetchAll();
    } catch (e) {
      _setError('Failed to delete transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Soft delete a transaction (mark as deleted)
  Future<void> softDelete(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.softDelete(transaction);
      await fetchAll();
    } catch (e) {
      _setError('Failed to soft delete transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Restore a soft-deleted transaction
  Future<void> restore(TransactionModel transaction) async {
    _setLoading(true);

    try {
      await _repository.restore(transaction);
      await fetchAll();
    } catch (e) {
      _setError('Failed to restore transaction: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Find transactions by type (income/expense)
  Future<List<TransactionModel>> findByType(TransactionTypeEnum type) async {
    _setLoading(true);

    try {
      return await _repository.findByType(type);
    } catch (e) {
      _setError('Failed to get transactions by type: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Find transactions in a date range
  Future<List<TransactionModel>> findByDateRange(DateTime start, DateTime end) async {
    _setLoading(true);

    try {
      return await _repository.findByDateRange(start, end);
    } catch (e) {
      _setError('Failed to get transactions by date range: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }
}