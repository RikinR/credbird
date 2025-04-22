import 'package:credbird/viewmodel/send_page_viewmodels/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class InvoiceListView extends StatefulWidget {
  const InvoiceListView({super.key});

  @override
  State<InvoiceListView> createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<InvoiceListView> {
  String _selectedView = 'assignedToMe';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoiceViewModel>(
        context,
        listen: false,
      ).loadInvoicesAssignedForMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InvoiceViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedView,
              decoration: InputDecoration(
                labelText: 'View',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'assignedToMe',
                  child: Text('Assigned To Me'),
                ),
                DropdownMenuItem(
                  value: 'assignedByMe',
                  child: Text('Assigned By Me'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedView = value!;
                });
                if (value == 'assignedToMe') {
                  viewModel.loadInvoicesAssignedForMe();
                } else {
                  viewModel.loadInvoicesAssignedByMe();
                }
              },
            ),
          ),
          Expanded(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildInvoiceList(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(InvoiceViewModel viewModel) {
    String formatDateTime(String? iso) {
      if (iso == null) return 'N/A';
      try {
        final dateTime = DateTime.parse(iso).toLocal();
        final date = DateFormat('dd/MM/yyyy').format(dateTime);
        final time = DateFormat('HH:mm').format(dateTime);
        return '$date at $time';
      } catch (e) {
        return 'Invalid date';
      }
    }

    final invoices =
        _selectedView == 'assignedToMe'
            ? viewModel.invoicesAssignedForMe
            : viewModel.invoicesAssignedByMe;

    if (invoices.isEmpty) {
      return const Center(child: Text('No invoices found'));
    }

    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        if (invoice is! Map<String, dynamic>) {
          return const ListTile(title: Text('Invalid invoice data'));
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice ID: ${invoice['invoiceId'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Status: ${invoice['status'] ?? 'N/A'}'),
                Text('Active: ${invoice['isActive'] ?? 'N/A'}'),
                Text('Amount: ${invoice['totalAmount'] ?? 'N/A'}'),
                Text('Remaining: ${invoice['remainingAmount'] ?? 'N/A'}'),
                if (invoice['currencyId'] is Map &&
                    invoice['currencyId']['currency'] != null)
                  Text('Currency: ${invoice['currencyId']['currency']}'),
                if (invoice['userId'] is Map &&
                    invoice['userId']['email'] != null)
                  Text('User Email: ${invoice['userId']['email']}'),
                if (invoice['agentId'] is Map &&
                    invoice['agentId']['email'] != null)
                  Text('Agent Email: ${invoice['agentId']['email']}'),
                const SizedBox(height: 8),
                Text(
                  'Created: ${formatDateTime(invoice['createdAt'])}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Updated: ${formatDateTime(invoice['updatedAt'])}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
