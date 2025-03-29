class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String? ifscCode;
  final String? swiftCode;
  final String? iban;
  final String? address;
  final String? mobileNumber;
  final String? email;
  final double? transferLimit;
  final bool isInternational;

  Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    this.ifscCode,
    this.swiftCode,
    this.iban,
    this.address,
    this.mobileNumber,
    this.email,
    this.transferLimit,
    this.isInternational = false,
  });
}
