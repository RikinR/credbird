class ApiTransaction {
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
  final String remitterName;
  final String remitterEmail;
  final String remitterPhone;
  final String? additionalDetails;

  ApiTransaction({
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
    required this.remitterName,
    required this.remitterEmail,
    required this.remitterPhone,
    this.additionalDetails,
  });

  factory ApiTransaction.fromJson(Map<String, dynamic> json) {
    
    T? safeGet<T>(dynamic value, [T? defaultValue]) {
      try {
        if (value is T) return value;
        return defaultValue;
      } catch (e) {
        return defaultValue;
      }
    }

    String safeString(dynamic value, [String defaultValue = '']) =>
        safeGet<String>(value, defaultValue) ?? defaultValue;

    double safeDouble(dynamic value, [double defaultValue = 0.0]) =>
        safeGet<double>(value, defaultValue) ?? defaultValue;

    DateTime safeDate(dynamic value, [DateTime? defaultValue]) {
      try {
        return DateTime.parse(value.toString());
      } catch (e) {
        return defaultValue ?? DateTime.now();
      }
    }

    final currencyData =
        safeGet<Map<String, dynamic>>(json['currencyId'], {}) ?? {};
    final beneficiaryData =
        safeGet<Map<String, dynamic>>(json['benificaryId'], {}) ?? {};
    final remittanceData =
        safeGet<Map<String, dynamic>>(json['remittanceTypeId'], {}) ?? {};
    final userData = safeGet<Map<String, dynamic>>(json['userId'], {}) ?? {};

    return ApiTransaction(
      id: safeString(json['_id']),
      transactionId: safeString(json['transId']),
      referenceNo: safeString(json['userReferenceNo']),
      currency: safeString(currencyData['currency']),
      currencyName: safeString(currencyData['currencyName']),
      beneficiaryName: safeString(beneficiaryData['benificiaryName']),
      status: safeString(json['status'], 'pending'),
      netAmount: json['invoices']?.isNotEmpty == true 
          ? safeDouble(json['invoices'][0]['amountPaid'])
          : safeDouble(json['netAmount']),
      createdAt: safeDate(json['createdAt']),
      remittanceType: safeString(remittanceData['name']),
      invoiceId: json['invoices']?.isNotEmpty == true 
          ? safeString(json['invoices'][0]['invoiceId']['invoiceId'])
          : null,
      invoiceAmount: json['invoices']?.isNotEmpty == true 
          ? safeDouble(json['invoices'][0]['invoiceId']['totalAmount'])
          : null,
      remitterName: safeString(userData['name']),
      remitterEmail: safeString(userData['email']),
      remitterPhone: safeString(
        userData['phone']?.toString() ?? '',
      ), 
      additionalDetails: safeString(json['additionalDetail'], ''),
    );
  }
}
