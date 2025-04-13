class ForexRate {
  final String currencyCode;
  final double inrBuy;
  final double inrSell;

  ForexRate({
    required this.currencyCode,
    required this.inrBuy,
    required this.inrSell,
  });

  factory ForexRate.fromJson(Map<String, dynamic> json) {
    return ForexRate(
      currencyCode: json['CurrencyCode'],
      inrBuy: double.tryParse(json['INRBuy'].toString()) ?? 0.0,
      inrSell: double.tryParse(json['INRSell'].toString()) ?? 0.0,
    );
  }
}