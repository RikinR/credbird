class Transaction {
  final String id;
  final String transactionId;
  final String referenceNo;
  final String currency;
  final String currencyName;
  final String beneficiaryName;
  final String status;
  final double netAmount;
  final DateTime createdAt;
  final String remittanceType;
  final String? invoiceId;
  final double? invoiceAmount;

  Transaction({
    required this.id,
    required this.transactionId,
    required this.referenceNo,
    required this.currency,
    required this.currencyName,
    required this.beneficiaryName,
    required this.status,
    required this.netAmount,
    required this.createdAt,
    required this.remittanceType,
    this.invoiceId,
    this.invoiceAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      transactionId: json['transId'],
      referenceNo: json['referenceNo'] ?? 'N/A',
      currency: json['currencyId']['currency'],
      currencyName: json['currencyId']['currencyName'],
      beneficiaryName: json['benificaryId']['benificiaryName'],
      status: json['status'],
      netAmount: json['netAmount']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      remittanceType: json['remittanceTypeId']['name'],
      invoiceId: json['invoices']?.isNotEmpty == true 
          ? json['invoices'][0]['invoiceId']['invoiceId'] 
          : null,
      invoiceAmount: json['invoices']?.isNotEmpty == true 
          ? json['invoices'][0]['amountPaid']?.toDouble() 
          : null,
    );
  }
}