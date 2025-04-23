// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';

class LRSInformationStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const LRSInformationStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<LRSInformationStep> createState() => _LRSInformationStepState();
}

class _LRSInformationStepState extends State<LRSInformationStep> {
  final List<Map<String, dynamic>> _lrsData = [];
  final TextEditingController _amountInrController = TextEditingController();
  final TextEditingController _amountUsdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _datesController = TextEditingController();
  String _selectedInfoType = 'Transaction Done outside the Pay2Remit in 24-25';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SendMoneyViewModel>(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LRS Data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Note: USD equivalent amount is to calculate the LRS limit.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedInfoType,
                    decoration: const InputDecoration(
                      labelText: "Transaction Type",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Transaction Done outside the Pay2Remit in 24-25',
                        child: Text('Transaction Done outside the Pay2Remit in 24-25'),
                      ),
                      DropdownMenuItem(
                        value: 'Transaction Done from the Pay2Remit in 24-25',
                        child: Text('Transaction Done from the Pay2Remit in 24-25'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedInfoType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountInrController,
                    decoration: const InputDecoration(
                      labelText: "Amount in INR (\$)",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountUsdController,
                    decoration: const InputDecoration(
                      labelText: "Amount in USD (\$) equivalent",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: "Name and Address",
                      hintText: "Enter comma separated Name and address of transactions done outside platform",
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _datesController,
                          decoration: const InputDecoration(
                            labelText: "Dates [DD/MM/YYYY]",
                            hintText: "Enter comma separated dates",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            final dateStr = "${picked.day}/${picked.month}/${picked.year}";
                            if (_datesController.text.isEmpty) {
                              _datesController.text = dateStr;
                            } else {
                              _datesController.text = "${_datesController.text}, $dateStr";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_amountInrController.text.isNotEmpty) {
                        setState(() {
                          _lrsData.add({
                            'info': _selectedInfoType,
                            'amount': _amountInrController.text,
                            'usdAmount': _amountUsdController.text.isEmpty 
                                ? 0 
                                : double.tryParse(_amountUsdController.text),
                            'address': _addressController.text,
                            'dates': _datesController.text,
                            'addressPlaceHolder': "Enter comma separated Name and address of transactions done outside platform",
                            'datesPlaceHolder': "Enter comma separated dates of transactions done outside",
                            'disabled': false,
                          });
                          
                          _amountInrController.clear();
                          _amountUsdController.clear();
                          _addressController.clear();
                          _datesController.clear();
                        });
                        
                        viewModel.addLRSInfo({
                          'info': _selectedInfoType,
                          'amount': _amountInrController.text,
                          'usdAmount': _amountUsdController.text.isEmpty 
                              ? 0 
                              : double.tryParse(_amountUsdController.text),
                          'address': _addressController.text,
                          'dates': _datesController.text,
                          'addressPlaceHolder': "Enter comma separated Name and address of transactions done outside platform",
                          'datesPlaceHolder': "Enter comma separated dates of transactions done outside",
                          'disabled': false,
                        });
                      }
                    },
                    child: const Text("Add LRS Entry"),
                  ),
                ],
              ),
            ),
          ),
          
          if (_lrsData.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Added LRS Entries:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._lrsData.map((entry) => ListTile(
              title: Text(entry['info']),
              subtitle: Text("Amount: ${entry['amount']} INR (${entry['usdAmount']} USD)"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _lrsData.remove(entry);
                  });
                },
              ),
            )),
          ],
          
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onContinue,
                  child: const Text("Continue to Invoice Details"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}