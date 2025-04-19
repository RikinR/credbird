class TransactionCreateModel {
  final String remitterId;
  final String beneficiaryId;
  final String remittanceTypeId;
  final String remittanceSubTypeId;
  final String intermediaryId;
  final String currencyId;
  final double amount;
  final String purpose;

  TransactionCreateModel({
    required this.remitterId,
    required this.beneficiaryId,
    required this.remittanceTypeId,
    required this.remittanceSubTypeId,
    required this.intermediaryId,
    required this.currencyId,
    required this.amount,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'remitterId': remitterId,
      'beneficiaryId': beneficiaryId,
      'remittanceTypeId': remittanceTypeId,
      'remittanceSubTypeId': remittanceSubTypeId,
      'intermediaryId': intermediaryId,
      'currencyId': currencyId,
      'amount': amount,
      'purpose': purpose,
    };
  }
}
