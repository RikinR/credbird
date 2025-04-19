// intermediary_provider.dart
import 'package:credbird/repositories/remitence_repository/intermediary_repository.dart';
import 'package:flutter/material.dart';

class IntermediaryProvider extends ChangeNotifier {
  final _intermediaryProvider = IntermediaryRepository();

  bool _isLoading = false;
  String? _error;
  String? _intermediaryId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get intermediaryId => _intermediaryId;

  Future<void> createIntermediary({
    required String intermediaryBankName,
    required String bicCode,
    required String intermediaryBankAddress,
    required String sortBsbAbaTransitFed,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _intermediaryProvider.createIntermediary(
        intermediaryBankName: intermediaryBankName,
        bicCode: bicCode,
        intermediaryBankAddress: intermediaryBankAddress,
        sortBsbAbaTransitFed: sortBsbAbaTransitFed,
      );

      _intermediaryId = response['_id'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
