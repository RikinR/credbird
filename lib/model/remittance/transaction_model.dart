class Transaction {
  final String recipient;
  final String date;
  final double amount;
  final bool isIncoming;
  final String? details;

  Transaction({
    required this.recipient,
    required this.date,
    required this.amount,
    required this.isIncoming,
    this.details,
  });
}