class DashboardCount {
  final int totalTransactions;
  final int successfulTransactions;
  final int failedTransactions;
  final int pendingTransactions;

  DashboardCount({
    required this.totalTransactions,
    required this.successfulTransactions,
    required this.failedTransactions,
    required this.pendingTransactions,
  });

  factory DashboardCount.fromJson(Map<String, dynamic> json) {
    return DashboardCount(
      totalTransactions: json['totalTransactions'] ?? 0,
      successfulTransactions: json['successfulTransactions'] ?? 0,
      failedTransactions: json['failedTransactions'] ?? 0,
      pendingTransactions: json['pendingTransactions'] ?? 0,
    );
  }
}