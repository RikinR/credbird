class BankDetail {
  final String accountNumber;
  final String ifsc;
  final String accountName;
  final String verifiedId;
  final bool refundAccount;
  final String status;
  final String verifiedStatus;
  final String? id;

  BankDetail({
    required this.accountNumber,
    required this.ifsc,
    required this.accountName,
    required this.verifiedId,
    this.refundAccount = false,
    this.status = 'ACTIVE',
    this.verifiedStatus = 'PENDING',
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "accountNumber": accountNumber,
      "ifsc": ifsc,
      "accountName": accountName,
      "verifiedId": verifiedId,
      "refundAccount": refundAccount,
      "status": status,
      "verifiedStatus": verifiedStatus,
      if (id != null) "_id": id,
    };
  }
}
