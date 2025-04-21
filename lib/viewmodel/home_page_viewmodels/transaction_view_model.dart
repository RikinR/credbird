
import 'package:credbird/model/remittance/transaction_response_model.dart';
import 'package:credbird/repositories/user_repository/transaction_repository.dart';
import 'package:flutter/material.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  
  TransactionResponse? _transactionResponse;
  int _currentPage = 1;
  final int _pageSize = 10;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  TransactionViewModel(this._repository);

  TransactionResponse? get transactionResponse => _transactionResponse;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getTransactions(
        page: _currentPage,
        pageSize: _pageSize,
        search: _searchQuery,
      );

      if (refresh) {
        _transactionResponse = response;
      } else {
        _transactionResponse = TransactionResponse(
          totalCount: response.totalCount,
          transactions: [
            ...?_transactionResponse?.transactions,
            ...response.transactions,
          ],
        );
      }

      _hasMore = response.transactions.length >= _pageSize;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTransactions(String query) async {
    _searchQuery = query;
    await loadTransactions(refresh: true);
  }

  void clearSearch() {
    _searchQuery = '';
    loadTransactions(refresh: true);
  }
}