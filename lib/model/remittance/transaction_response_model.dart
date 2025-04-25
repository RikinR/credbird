import 'package:credbird/model/user_models/api_transaction_model.dart';

class TransactionResponse {
  final int totalCount;
  final List<ApiTransaction> transactions;

  TransactionResponse({required this.totalCount, required this.transactions});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      totalCount: json['totalCount'] as int? ?? 0,
      transactions:
          (json['transactions'] as List?)
              ?.map(
                (item) => ApiTransaction.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
