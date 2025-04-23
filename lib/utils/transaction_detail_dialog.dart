
import 'package:credbird/model/user_models/api_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showTransactionDetailDialog(BuildContext context, ApiTransaction transaction) {
  final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
  final currencyFormat = NumberFormat.currency(symbol: transaction.currency);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Transaction Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Transaction ID', transaction.transactionId),
            _buildDetailRow('Reference No', transaction.referenceNo),
            _buildDetailRow('Date', dateFormat.format(transaction.createdAt)),
            _buildDetailRow('Status', transaction.status),
            _buildDetailRow('Remittance Type', transaction.remittanceType),
            SizedBox(height: 16),
            Text('Sender Details', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Name', transaction.remitterName),
            _buildDetailRow('Email', transaction.remitterEmail),
            _buildDetailRow('Phone', transaction.remitterPhone),
            SizedBox(height: 16),
            Text('Beneficiary Details', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Name', transaction.beneficiaryName),
            SizedBox(height: 16),
            Text('Amount Details', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Net Amount', currencyFormat.format(transaction.netAmount)),
            if (transaction.invoiceAmount != null)
              _buildDetailRow('Invoice Amount', currencyFormat.format(transaction.invoiceAmount!)),
            if (transaction.additionalDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text('Additional Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(transaction.additionalDetails!),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    ),
  );
}