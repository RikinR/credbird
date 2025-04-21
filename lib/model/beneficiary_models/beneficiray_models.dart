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
  final String city;
  final String country;
  final String bankAddress;
  final String? ibanBsbAba;
  final bool? isActivated;

  Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    this.isActivated =true,
    this.ifscCode,
    this.swiftCode,
    this.iban,
    this.address,
    this.mobileNumber,
    this.email,
    this.transferLimit,
    this.isInternational = false,
    required this.city,
    required this.country,
    required this.bankAddress,
    this.ibanBsbAba,
  });
}