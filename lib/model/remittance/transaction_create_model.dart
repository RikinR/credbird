class TransactionCreateModel {
  final String remitterId;
  final String beneficiaryId;
  final String remittanceTypeId;
  final String remittanceSubTypeId;
  final String? intermediaryId;
  final String currencyId;
  final double amount;
  final String purpose;
  final String nostroCharge;
  final List<Invoice> invoices;
  final List<Lrs>? lrsList;

  TransactionCreateModel({
    required this.remitterId,
    required this.beneficiaryId,
    required this.remittanceTypeId,
    required this.remittanceSubTypeId,
    this.intermediaryId,
    required this.currencyId,
    required this.amount,
    required this.purpose,
    required this.nostroCharge,
    required this.invoices,
    this.lrsList,
  });

  Map<String, dynamic> toJson() {
    return {
      'remitterId': remitterId,
      'benificaryId': beneficiaryId,
      'remittanceTypeId': remittanceTypeId,
      'remittanceSubTypeId': remittanceSubTypeId,
      'intermediaryId': intermediaryId,
      'currencyId': currencyId,
      'netAmount': amount,
      'additionalDetail': purpose,
      'nostroCharge': nostroCharge,
      'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
      if (lrsList != null)
        'lrsList': lrsList!.map((lrs) => lrs.toJson()).toList(),
    };
  }
}

class Invoice {
  final String invoiceId;
  final double totalAmount;
  final double remainingAmount;
  final double paidAmount;
  final String reason;
  final bool? showReason;

  Invoice({
    required this.invoiceId,
    required this.totalAmount,
    required this.remainingAmount,
    required this.paidAmount,
    required this.reason,
    this.showReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'paidAmount': paidAmount,
      'reason': reason,
      if (showReason != null) 'showReason': showReason,
    };
  }
}

class Lrs {
  final String? address;
  final String? addressPlaceHolder;
  final String? datesPlaceHolder;
  final String? amount;
  final String? dates;
  final double? usdAmount;
  final String info;
  final bool? disabled;

  Lrs({
    this.address,
    this.addressPlaceHolder,
    this.datesPlaceHolder,
    this.amount,
    this.dates,
    this.usdAmount,
    required this.info,
    this.disabled,
  });

  Map<String, dynamic> toJson() {
    return {
      if (address != null) 'address': address,
      if (addressPlaceHolder != null) 'addressPlaceHolder': addressPlaceHolder,
      if (datesPlaceHolder != null) 'datesPlaceHolder': datesPlaceHolder,
      if (amount != null) 'amount': amount,
      if (dates != null) 'dates': dates,
      if (usdAmount != null) 'usdAmount': usdAmount,
      'info': info,
      if (disabled != null) 'disabled': disabled,
    };
  }
}
