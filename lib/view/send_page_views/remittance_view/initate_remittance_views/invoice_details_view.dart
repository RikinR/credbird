// ignore_for_file: unused_local_variable

import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';

class InvoiceDetailsStep extends StatefulWidget {
  final VoidCallback onBack;

  const InvoiceDetailsStep({super.key, required this.onBack});

  @override
  State<InvoiceDetailsStep> createState() => _InvoiceDetailsStepState();
}

class _InvoiceDetailsStepState extends State<InvoiceDetailsStep> {
  final List<Map<String, dynamic>> _invoices = [];
  final TextEditingController _invoiceIdController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _transferAmountController =
      TextEditingController();
  bool _educationDeclaration = false;
  final TextEditingController _educationDeclarationNumberController =
      TextEditingController();
  final TextEditingController _educationDeclarationAmountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SendMoneyViewModel>(context);

    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final isOverseasEducation =
        viewModel.selectedRemittanceTypeId == "6332c5c737a25f1236f9f841";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill details in below form.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "For Overseas Education Remittance, instead of Invoice No. you may use Student ID No., Application No. or Person No., etc.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Invoice detail form",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _invoiceIdController,
                    decoration: const InputDecoration(
                      labelText: "Select Invoice Number*",
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _totalAmountController,
                    decoration: const InputDecoration(
                      labelText: "Invoice FX Amt*",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _transferAmountController,
                    decoration: const InputDecoration(
                      labelText: "Transfer Amt*",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme["buttonHighlight"],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _addInvoice,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Add Invoice",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme["backgroundColor"],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOverseasEducation) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Education Declaration",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SwitchListTile(
                      title: const Text(
                        "This transaction is for education loan",
                      ),
                      value: _educationDeclaration,
                      onChanged: (value) {
                        setState(() {
                          _educationDeclaration = value;
                        });
                      },
                    ),
                    if (_educationDeclaration) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _educationDeclarationNumberController,
                        decoration: const InputDecoration(
                          labelText: "Education Declaration Number*",
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _educationDeclarationAmountController,
                        decoration: const InputDecoration(
                          labelText: "Education Declaration Amount*",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          if (_invoices.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Added Invoices:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._invoices.map(
                  (invoice) => ListTile(
                    title: Text("Invoice #${invoice['invoiceId']}"),
                    subtitle: Text(
                      "Amount: ${invoice['totalAmount']} (Transfer: ${invoice['transferAmount']})",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeInvoice(invoice),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme["buttonHighlight"],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: widget.onBack,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme["backgroundColor"],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme["buttonHighlight"],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      _invoices.isEmpty && !_educationDeclaration
                          ? null
                          : () {
                            if (_invoices.isEmpty && _educationDeclaration) {
                              if (_educationDeclarationNumberController
                                      .text
                                      .isEmpty ||
                                  _educationDeclarationAmountController
                                      .text
                                      .isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill education declaration fields",
                                    ),
                                  ),
                                );
                                return;
                              }
                            } else if (_invoices.isEmpty &&
                                !_educationDeclaration) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please add either an invoice or education declaration",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (isOverseasEducation) {
                              viewModel.educationDeclaration =
                                  _educationDeclaration;
                              if (_educationDeclaration) {
                                viewModel.educationDeclarationNumber =
                                    _educationDeclarationNumberController.text;
                                viewModel.educationDeclarationAmount =
                                    double.tryParse(
                                      _educationDeclarationAmountController
                                          .text,
                                    ) ??
                                    0;
                              }
                            }

                            viewModel.createRemittanceTransaction(context);
                          },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Transaction",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme["backgroundColor"],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (viewModel.transactionError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                viewModel.transactionError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  void _addInvoice() {
    if (_invoiceIdController.text.isEmpty ||
        _totalAmountController.text.isEmpty ||
        _transferAmountController.text.isEmpty) {
      return;
    }

    final newInvoice = {
      'invoiceId': _invoiceIdController.text,
      'totalAmount': double.tryParse(_totalAmountController.text) ?? 0,
      'transferAmount': double.tryParse(_transferAmountController.text) ?? 0,
    };

    setState(() {
      _invoices.add(newInvoice);
      _invoiceIdController.clear();
      _totalAmountController.clear();
      _transferAmountController.clear();
    });
    final viewModel = Provider.of<SendMoneyViewModel>(context, listen: false);
    viewModel.addInvoice(newInvoice);
  }

  void _removeInvoice(Map<String, dynamic> invoice) {
    setState(() {
      _invoices.remove(invoice);
    });

    final viewModel = Provider.of<SendMoneyViewModel>(context, listen: false);
    viewModel.invoices.remove(invoice);
  }
}
