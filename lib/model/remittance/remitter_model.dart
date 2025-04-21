class RemitterModel {
  final String remitterType;
  final String remitterPan;
  final String panVerifiedId;
  final String remitterName;
  final double? tcsRate;
  final String remitterAddressProofType;
  final String remitterAddressProof;
  final String? placeOfIssue;
  final String? dateOfIssue;
  final String? dateOfExpiry;
  final String mobile;
  final String emailId;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pin;
  final String accountNumber;
  final String ifsc;
  final String accountName;
  final String accountVerifiedId;
  
  final String? relationship;
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
    this.tcsRate,
    required this.remitterAddressProofType,
    required this.remitterAddressProof,
    this.placeOfIssue,
    this.dateOfIssue,
    this.dateOfExpiry,
    required this.mobile,
    required this.emailId,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pin,
    required this.accountNumber,
    required this.ifsc,
    required this.accountName,
    required this.accountVerifiedId,
    this.relationship,
    this.travellerFullName,
    this.passportNo,
    this.studentPlaceOfIssue,
    this.studentDateOfIssue,
    this.studentDateOfExpiry,
    this.studentAddress,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'remitterType': remitterType,
      'remitterPan': remitterPan,
      'panVerifiedId': panVerifiedId,
      'remitterName': remitterName,
      'tcsRate': tcsRate,
      'remitterAddressProofType': remitterAddressProofType,
      'remitterAddressProof': remitterAddressProof,
      'mobile': mobile,
      'emailId': emailId,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pin': pin,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'accountName': accountName,
      'accountVerifiedId': accountVerifiedId,
    };

    if (remitterType == 'Self') {
      map.addAll({
        'placeOfIssue': placeOfIssue,
        'dateOfIssue': dateOfIssue,
        'dateOfExpiry': dateOfExpiry,
      });
    } else if (remitterType == 'Guardian') {
      map.addAll({
        'relationship': relationship,
        'travellerFullName': travellerFullName,
        'passportNo': passportNo,
        'studentPlaceOfIssue': studentPlaceOfIssue,
        'studentDateOfIssue': studentDateOfIssue,
        'studentDateOfExpiry': studentDateOfExpiry,
        'studentAddress': studentAddress,
      });
    }

    return map;
  }

}