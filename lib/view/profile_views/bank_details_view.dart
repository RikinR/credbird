// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/profile_providers/bank_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: const Text("Bank Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
      ),
      body: const _BankDetailsForm(),
    );
  }
}

class _BankDetailsForm extends StatefulWidget {
  const _BankDetailsForm();

  @override
  State<_BankDetailsForm> createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<_BankDetailsForm> {
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscController;
  late TextEditingController _accountNameController;

  @override
  void initState() {
    super.initState();
    final bankProvider = Provider.of<BankProvider>(context, listen: false);
    _accountNumberController = TextEditingController(
      text: bankProvider.bankData.accountNumber,
    );
    _ifscController = TextEditingController(text: bankProvider.bankData.ifsc);
    _accountNameController = TextEditingController(
      text: bankProvider.bankData.accountName,
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ifscController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final bankProvider = Provider.of<BankProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(
              context,
              "Account Number",
              "Enter your account number",
              _accountNumberController,
              Icons.credit_card,
              (value) => bankProvider.updateBankDetails(accountNumber: value),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "IFSC Code",
              "Enter your bank's IFSC code",
              _ifscController,
              Icons.code,
              (value) => bankProvider.updateBankDetails(ifsc: value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "Account Name",
              "Enter account holder name",
              _accountNameController,
              Icons.person,
              (value) => bankProvider.updateBankDetails(accountName: value),
            ),
            const SizedBox(height: 24),
            if (bankProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  bankProvider.errorMessage!,
                  style: TextStyle(color: theme["negativeAmount"]),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bankProvider.isLoading
                    ? null
                    : () async {
                        await bankProvider.submitBankDetails();
                        if (!bankProvider.isLoading) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bank details updated successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["textColor"],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: bankProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Save Bank Details",
                        style: TextStyle(
                          color: theme["backgroundColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller,
    IconData icon,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme["textColor"]),
        labelStyle: TextStyle(color: theme["secondaryText"]),
        hintStyle: TextStyle(color: theme["secondaryText"]?.withOpacity(0.6)),
        filled: true,
        fillColor: theme["cardBackground"],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: TextStyle(color: theme["textColor"]),
    );
  }
}