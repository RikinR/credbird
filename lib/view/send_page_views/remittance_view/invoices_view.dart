import 'package:credbird/viewmodel/send_page_viewmodels/invoices_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Invoice Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.iconTheme.color,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DropdownButtonFormField<String>(
                value: _selectedView,
                decoration: InputDecoration(
                  labelText: 'View Invoices',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Provider.of<ThemeProvider>(
                          context,
                        ).themeConfig["buttonHighlight"],
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          Provider.of<ThemeProvider>(
                            context,
                          ).themeConfig["buttonHighlight"],
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          Provider.of<ThemeProvider>(
                            context,
                          ).themeConfig["buttonHighlight"],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          Provider.of<ThemeProvider>(
                            context,
                          ).themeConfig["buttonHighlight"],
                    ),
                  ),
                ),
                iconEnabledColor:
                    Provider.of<ThemeProvider>(
                      context,
                    ).themeConfig["buttonHighlight"],
                dropdownColor: theme.cardColor,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                items: [
                  DropdownMenuItem(
                    value: 'assignedToMe',
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          color: theme.iconTheme.color,
                        ), 
                        const SizedBox(width: 8),
                        Text('Assigned To Me'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'assignedByMe',
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_ind,
                          color: theme.iconTheme.color,
                        ), 
                        const SizedBox(width: 8),
                        Text('Assigned By Me'),
                      ],
                    ),
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
          ),

          Expanded(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildInvoiceList(viewModel, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(InvoiceViewModel viewModel, ThemeData theme) {
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
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _infoText('Status', invoice['status']),
                    _infoText('Active', invoice['isActive'].toString()),
                    _infoText('Amount', invoice['totalAmount'].toString()),
                    _infoText(
                      'Remaining',
                      invoice['remainingAmount'].toString(),
                    ),
                    if (invoice['currencyId'] is Map &&
                        invoice['currencyId']['currency'] != null)
                      _infoText('Currency', invoice['currencyId']['currency']),
                    if (invoice['userId'] is Map &&
                        invoice['userId']['email'] != null)
                      _infoText('User Email', invoice['userId']['email']),
                    if (invoice['agentId'] is Map &&
                        invoice['agentId']['email'] != null)
                      _infoText('Agent Email', invoice['agentId']['email']),
                  ],
                ),
                const SizedBox(height: 12),
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

  Widget _infoText(String label, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value ?? 'N/A'),
      ],
    );
  }
}
