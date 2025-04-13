class AdditionalDetailsModel {
  final String? businessAddress;
  final String? businessCity;
  final String? businessCountry;
  final String? businessPin;
  final String? businessState;

  AdditionalDetailsModel({
    this.businessAddress,
    this.businessCity,
    this.businessCountry,
    this.businessPin,
    this.businessState,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessAddress': businessAddress,
      'businessCity': businessCity,
      'businessCountry': businessCountry,
      'businessPin': businessPin,
      'businessState': businessState,
    };
  }
}
