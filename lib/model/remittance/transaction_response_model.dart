
import 'package:credbird/model/remittance/remittance_transaction_model.dart';

class TransactionResponse {
  final int totalCount;
  final List<Transaction> transactions;

  TransactionResponse({
    required this.totalCount,
    required this.transactions,
  });

  factory TransactionResponse.fromJson(List<dynamic> json) {
    return TransactionResponse(
      totalCount: json[0],
      transactions: (json[1] as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
    );
  }
}