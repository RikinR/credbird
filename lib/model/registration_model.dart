class RegistrationModel {
  String? passport;
  String? mobile;
  String? email;
  String? orgAddress;
  String? orgPin;
  String? orgCity;
  String? orgState;
  String? orgCountry;

  String? panNumber;
  String? fullName;
  double? tcsRate;
  String? verifiedId;

  String? businessAddress;
  String? businessPin;
  String? businessCity;
  String? businessState;
  String? businessCountry;

  List<BankDetail> bankDetails = [];
  List<ContactDetail> contactDetails = [];

  RegistrationModel({
    this.passport,
    this.mobile,
    this.email,
    this.orgAddress,
    this.orgPin,
    this.orgCity,
    this.orgState,
    this.orgCountry,
    this.panNumber,
    this.fullName,
    this.tcsRate,
    this.verifiedId,
    this.businessAddress,
    this.businessPin,
    this.businessCity,
    this.businessState,
    this.businessCountry,
  });

  RegistrationModel copyWith({
    String? passport,
    String? mobile,
    String? email,
    String? orgAddress,
    String? orgPin,
    String? orgCity,
    String? orgState,
    String? orgCountry,
    String? panNumber,
    String? fullName,
    double? tcsRate,
    String? verifiedId,
    String? businessAddress,
    String? businessPin,
    String? businessCity,
    String? businessState,
    String? businessCountry,
    List<BankDetail>? bankDetails,
    List<ContactDetail>? contactDetails,
  }) {
    return RegistrationModel(
      passport: passport ?? this.passport,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      orgAddress: orgAddress ?? this.orgAddress,
      orgPin: orgPin ?? this.orgPin,
      orgCity: orgCity ?? this.orgCity,
      orgState: orgState ?? this.orgState,
      orgCountry: orgCountry ?? this.orgCountry,
      panNumber: panNumber ?? this.panNumber,
      fullName: fullName ?? this.fullName,
      tcsRate: tcsRate ?? this.tcsRate,
      verifiedId: verifiedId ?? this.verifiedId,
      businessAddress: businessAddress ?? this.businessAddress,
      businessPin: businessPin ?? this.businessPin,
      businessCity: businessCity ?? this.businessCity,
      businessState: businessState ?? this.businessState,
      businessCountry: businessCountry ?? this.businessCountry,
    )..bankDetails = bankDetails ?? this.bankDetails
     ..contactDetails = contactDetails ?? this.contactDetails;
  }
}

class BankDetail {
  final String accountNumber;
  final String ifsc;
  final String accountName;
  final String verifiedId;
  final bool refundAccount;
  final String status;

  BankDetail({
    required this.accountNumber,
    required this.ifsc,
    required this.accountName,
    required this.verifiedId,
    this.refundAccount = true,
    this.status = 'ACTIVE',
  });

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'accountName': accountName,
      'verifiedId': verifiedId,
      'refundAccount': refundAccount,
      'status': status,
      '_id': '',
    };
  }
}

class ContactDetail {
  final String name;
  final String mobile;
  final String email;

  ContactDetail({
    required this.name,
    required this.mobile,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      '_id': '',
    };
  }
}
