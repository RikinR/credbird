import 'package:credbird/model/user_models/dashboard_count.dart';
import 'package:credbird/repositories/user_repository/dashboard_repository.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository;
  DashboardCount? _dashboardCount;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isLoading = false;
  String? _error;

  DashboardViewModel(this._repository);

  DashboardCount? get dashboardCount => _dashboardCount;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardCount() async {
    if (_fromDate == null || _toDate == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fromDateStr = _fromDate!.toLocal().toString().split(' ')[0];
      final toDateStr = _toDate!.toLocal().toString().split(' ')[0];
      
      _dashboardCount = await _repository.getDashboardCount(
        fromDate: fromDateStr,
        toDate: toDateStr,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFromDate(DateTime date) {
    _fromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime date) {
    _toDate = date;
    notifyListeners();
  }
}