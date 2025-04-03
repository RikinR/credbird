class KYCModel {
  final String? firstName;
  final String? lastName;
  final String? accountNumber;
  final String? ifsc;
  final String? accountName;
  final bool? refundAccount;
  final String? verifiedStatus;
  final String? status;
  final String? documentType;
  final String? documentPath;

  KYCModel({
    this.firstName,
    this.lastName,
    this.accountNumber,
    this.ifsc,
    this.accountName,
    this.refundAccount,
    this.verifiedStatus = "PENDING",
    this.status = "ACTIVE",
    this.documentType,
    this.documentPath,
  });
}