class KYCModel {
  final String? firstName;
  final String? lastName;
  final String? verifiedStatus;
  final String? status;
  final String? documentType;
  final String? documentPath;

  KYCModel({
    this.firstName,
    this.lastName,
    this.verifiedStatus = "PENDING",
    this.status = "ACTIVE",
    this.documentType,
    this.documentPath,
  });
}