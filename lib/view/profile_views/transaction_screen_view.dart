import 'package:credbird/model/transaction_model.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "Transaction History",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: theme["textColor"],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme["textColor"]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: homeViewModel.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = homeViewModel.transactions[index];
                  return _buildTransactionItem(transaction, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    Transaction transaction,
    Map<String, dynamic> theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme["cardBackground"],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: transaction.isIncoming
                ? theme["positiveAmount"].withOpacity(0.1)
                : theme["negativeAmount"].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            transaction.isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.isIncoming
                ? theme["positiveAmount"]
                : theme["negativeAmount"],
          ),
        ),
        title: Text(
          transaction.recipient,
          style: TextStyle(
            color: theme["textColor"],
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transaction.date,
          style: TextStyle(color: theme["secondaryText"], fontFamily: 'Roboto'),
        ),
        trailing: Text(
          "${transaction.isIncoming ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: transaction.isIncoming
                ? theme["positiveAmount"]
                : theme["negativeAmount"],
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}