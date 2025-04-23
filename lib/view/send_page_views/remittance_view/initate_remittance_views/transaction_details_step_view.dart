import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';

class TransactionDetailsStep extends StatelessWidget {
  final VoidCallback onContinue;

  const TransactionDetailsStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SendMoneyViewModel>(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Fill details in below form",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDropdown("Remittance Type", viewModel.remittanceTypes, (val) {
            viewModel.selectedRemittanceTypeId = val.toString();
            viewModel.loadSubTypes(val.toString());
          }, theme),
          _buildDropdown("Remittance Sub-Type", viewModel.subTypes, (val) {
            viewModel.selectedRemittanceSubTypeId = val.toString();
          }, theme),
          _buildDropdown("Beneficiary", viewModel.beneficiaries, (val) {
            viewModel.selectedBeneficiaryId = val.toString();
          }, theme),
          _buildDropdown("Remitter", viewModel.remitters, (val) {
            viewModel.selectedRemitterId = val.toString();
          }, theme),
          _buildDropdown(
            "Intermediary",
            viewModel.intermediaries,
            (val) {
              viewModel.selectedIntermediaryId = val.toString();
            },
            theme,
            labelKey: "intermediaryBankName",
          ),
          _buildDropdown(
            "Currency",
            viewModel.currencies,
            (val) {
              viewModel.selectedCurrencyId = val.toString();
            },
            theme,
            labelKey: "currency",
          ),
          _buildDropdown<String>(
            "Nostro Charge",
            const [
              "SHA",
              "BEN",
              "OUR",
            ].map((e) => {"name": e, "_id": e}).toList(),
            (val) {
              viewModel.setNostroCharge(val);
            },
            theme,
            labelKey: "name",
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.purposeController,
            decoration: InputDecoration(
              labelText: "Additional Details (Sender to Beneficiary)",
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (viewModel.selectedRemittanceTypeId != null &&
                  viewModel.selectedRemittanceSubTypeId != null &&
                  viewModel.selectedBeneficiaryId != null &&
                  viewModel.selectedRemitterId != null &&
                  viewModel.selectedCurrencyId != null &&
                  viewModel.nostroCharge.isNotEmpty &&
                  viewModel.purpose.isNotEmpty) {
                onContinue();
              }
            },
            child: const Text("Continue to LRS Information"),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    List<Map<String, dynamic>> items,
    void Function(T?) onChanged,
    ThemeData theme, {
    String labelKey = 'name',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
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
              return DropdownMenuItem<T>(
                value: item["_id"] as T?,
                child: Text(displayText),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
