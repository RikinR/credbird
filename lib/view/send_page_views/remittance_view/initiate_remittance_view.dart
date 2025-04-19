// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';

class InitiateRemittanceScreen extends StatefulWidget {
  const InitiateRemittanceScreen({super.key});

  @override
  State<InitiateRemittanceScreen> createState() =>
      _InitiateRemittanceScreenState();
}

class _InitiateRemittanceScreenState extends State<InitiateRemittanceScreen> {
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SendMoneyViewModel>(
        context,
        listen: false,
      ).loadDropdownData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SendMoneyViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Initiate Remittance",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDropdown("Remitter", viewModel.remitters, (val) {
                      viewModel.selectedRemitterId = val;
                    }, theme),
                    _buildDropdown("Beneficiary", viewModel.beneficiaries, (
                      val,
                    ) {
                      viewModel.selectedBeneficiaryId = val;
                    }, theme),
                    _buildDropdown(
                      "Remittance Type",
                      viewModel.remittanceTypes,
                      (val) {
                        viewModel.selectedRemittanceTypeId = val;
                        viewModel.loadSubTypes(val!);
                      },
                      theme,
                    ),
                    _buildDropdown("Remittance Sub-Type", viewModel.subTypes, (
                      val,
                    ) {
                      viewModel.selectedRemittanceSubTypeId = val;
                    }, theme),
                    _buildDropdown(
                      "Intermediary",
                      viewModel.intermediaries,
                      (val) {
                        viewModel.selectedIntermediaryId = val;
                      },
                      theme,
                      labelKey: "intermediaryBankName",
                    ),
                    _buildDropdown(
                      "Currency",
                      viewModel.currencies,
                      (val) {
                        viewModel.selectedCurrencyId = val;
                      },
                      theme,
                      labelKey: "currency",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _purposeController,
                      decoration: InputDecoration(
                        labelText: "Purpose",
                        labelStyle: TextStyle(color: theme.primaryColor),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => viewModel.purpose = val,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        labelStyle: TextStyle(color: theme.primaryColor),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: theme.primaryColor,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged:
                          (val) =>
                              viewModel.updateAmount(double.tryParse(val) ?? 0),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Create Transaction",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<Map<String, dynamic>> items,
    void Function(String?) onChanged,
    ThemeData theme, {
    String labelKey = 'name',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.primaryColor),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        isExpanded: true,
        items:
            items.map((item) {
              final displayText =
                  item[labelKey] ??
                  item["benificiaryName"] ??
                  item["remitterName"] ??
                  "Unnamed";
              return DropdownMenuItem<String>(
                value: item["_id"],
                child: Text(
                  displayText,
                  style: const TextStyle(fontFamily: 'Roboto'),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
