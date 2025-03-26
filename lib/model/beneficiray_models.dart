class Beneficiary {
  final String id;
  final String name;
  final String credBirdId;
  final String? bankAccount;
  final String? bankName;
  final String? ifscCode;

  Beneficiary({
    required this.id,
    required this.name,
    required this.credBirdId,
    this.bankAccount,
    this.bankName,
    this.ifscCode,
  });
}
