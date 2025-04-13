class BankModel {
  final String? accountNumber;
  final String? ifsc;
  final String? accountName;
  final bool? refundAccount;
  final String? verifiedStatus;
  final String? status;

  BankModel({
    this.accountNumber,
    this.ifsc,
    this.accountName,
    this.refundAccount = false,
    this.verifiedStatus = "PENDING",
    this.status = "ACTIVE",
  });
}