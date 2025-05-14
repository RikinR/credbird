// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:credbird/model/user_models/api_transaction_model.dart';
import 'package:credbird/utils/transaction_detail_dialog.dart';
import 'package:credbird/view/send_page_views/payment_link_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/documents_upload_view.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionScreenView extends StatefulWidget {
  const TransactionScreenView({super.key});

  @override
  State<TransactionScreenView> createState() => _TransactionScreenViewState();
}

class _TransactionScreenViewState extends State<TransactionScreenView> {
  @override
  void initState() {
    super.initState();
    print("transaction_screen_view");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionViewModel>(
        context,
        listen: false,
      ).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadTransactions(refresh: true),
          ),
        ],
      ),
      body: _buildBody(viewModel, theme),
    );
  }

  Widget _buildBody(TransactionViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading && viewModel.transactionResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${viewModel.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadTransactions(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final transactions = viewModel.transactionResponse?.transactions ?? [];
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search transactions...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: viewModel.searchTransactions,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length + (viewModel.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= transactions.length) {
                return _buildLoadMore(viewModel);
              }
              final transaction = transactions[index];
              return _buildTransactionItem(transaction, dateFormat, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMore(TransactionViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child:
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () => viewModel.loadTransactions(),
                  child: const Text('Load More'),
                ),
      ),
    );
  }

  Widget _buildTransactionItem(
    ApiTransaction transaction,
    DateFormat dateFormat,
    ThemeData theme,
  ) {
    final statusColor =
        transaction.status == 'VERIFIED'
            ? Colors.green
            : transaction.status == 'PENDING'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(transaction.beneficiaryName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(transaction.createdAt)),
            Chip(
              label: Text(
                transaction.status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: statusColor,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.currency} ${transaction.netAmount.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          final transactionVM = Provider.of<TransactionViewModel>(
            context,
            listen: false,
          );

          final transactionDetail = await transactionVM
              .fetchTransactionDetailById(transaction.id);

          if (transactionDetail == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to fetch transaction details."),
              ),
            );
            return;
          }

          final invoices =
              transactionDetail['invoices'] as List<dynamic>? ?? [];
          bool hasPendingDocuments = false;

          for (var invoice in invoices) {
            final docs = invoice['document'] as List<dynamic>? ?? [];
            for (var doc in docs) {
              final status = doc['status']?.toString().toLowerCase();
              if (status == 'pending') {
                hasPendingDocuments = true;
                break;
              }
            }
            if (hasPendingDocuments) break;
          }

          final status = (transaction.status).toLowerCase();
          if (status == 'pending' || status == 'verified') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => PaymentLinkScreen(
                      transactionId: transaction.id,
                      status: status,
                    ),
              ),
            );
          } else if (hasPendingDocuments) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => UploadDocumentsView(
                      transactionId: transaction.id,
                      esign: true,
                    ),
              ),
            );
          } else {
            showTransactionDetailDialog(context, transaction);
          }
        },
      ),
    );
  }
}
