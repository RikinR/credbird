class RemitterModel {
  final String remitterType;
  final String remitterPan;
  final String panVerifiedId;
  final String remitterName;
  final double tcsRate;
  final String remitterAddressProofType;
  final String remitterAddressProof;
  final String? placeOfIssue;
  final String? dateOfIssue;
  final String? dateOfExpiry;
  final String mobile;
  final String emailId;
  final String address;
  final String country;
  final String state;
  final String city;
  final String pin;
  final String? relationship;
  final String accountNumber;
  final String ifsc;
  final String accountName;
  final String accountVerifiedId;
  final String? travellerFullName;
  final String? passportNo;
  final String? studentPlaceOfIssue;
  final String? studentDateOfIssue;
  final String? studentDateOfExpiry;
  final String? studentAddress;

  RemitterModel({
    required this.remitterType,
    required this.remitterPan,
    required this.panVerifiedId,
    required this.remitterName,
    required this.tcsRate,
    required this.remitterAddressProofType,
    required this.remitterAddressProof,
    this.placeOfIssue,
    this.dateOfIssue,
    this.dateOfExpiry,
    required this.mobile,
    required this.emailId,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.pin,
    this.relationship,
    required this.accountNumber,
    required this.ifsc,
    required this.accountName,
    required this.accountVerifiedId,
    this.travellerFullName,
    this.passportNo,
    this.studentPlaceOfIssue,
    this.studentDateOfIssue,
    this.studentDateOfExpiry,
    this.studentAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "remitterType": remitterType,
      "remitterPan": remitterPan,
      "panVerifiedId": panVerifiedId,
      "remitterName": remitterName,
      "tcsRate": tcsRate,
      "remitterAddressProofType": remitterAddressProofType,
      "remitterAddressProof": remitterAddressProof,
      if (placeOfIssue != null) "placeOfIssue": placeOfIssue,
      if (dateOfIssue != null) "dateOfIssue": dateOfIssue,
      if (dateOfExpiry != null) "dateOfExpiry": dateOfExpiry,
      "mobile": mobile,
      "emailId": emailId,
      "address": address,
      "country": country,
      "state": state,
      "city": city,
      "pin": pin,
      if (relationship != null) "relationship": relationship,
      "accountNumber": accountNumber,
      "Ifsc": ifsc,
      "accountName": accountName,
      "accountVerifiedId": accountVerifiedId,
      if (travellerFullName != null) "travellerFullName": travellerFullName,
      if (passportNo != null) "passportNo": passportNo,
      if (studentPlaceOfIssue != null) "studentPlaceOfIssue": studentPlaceOfIssue,
      if (studentDateOfIssue != null) "studentDateOfIssue": studentDateOfIssue,
      if (studentDateOfExpiry != null) "studentDateOfExpiry": studentDateOfExpiry,
      if (studentAddress != null) "studentAddress": studentAddress,
    };
  }
}
