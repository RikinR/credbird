// ignore_for_file: use_build_context_synchronously

import 'package:credbird/model/beneficiary_models/beneficiray_models.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBeneficiaryPage extends StatefulWidget {
  const AddBeneficiaryPage({super.key});

  @override
  State<AddBeneficiaryPage> createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _swiftCodeController = TextEditingController();
  final _ibanBsbAbaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<BeneficiaryProvider>(
            context,
            listen: false,
          ).loadCurrencyList(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _bankAddressController.dispose();
    _swiftCodeController.dispose();
    _ibanBsbAbaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<BeneficiaryProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Add Beneficiary",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: "Beneficiary's Full Name",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _cityController,
                        label: "City",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _countryController,
                        label: "Country",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _accountNumberController,
                        label: "Account Number",
                        theme: theme,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        controller: _bankNameController,
                        label: "Bank Name",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _bankAddressController,
                        label: "Bank Address",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _swiftCodeController,
                        label: "SWIFT Code",
                        theme: theme,
                      ),
                      _buildTextField(
                        controller: _ibanBsbAbaController,
                        label: "IBAN/BSB/ABA",
                        theme: theme,
                      ),
                      _buildDropdown(
                        "Currency",
                        viewModel.currencies,
                        (val) =>
                            viewModel.selectedCurrencyId = val.toString(),
                        theme,
                        labelKey: "currency",
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final beneficiary = Beneficiary(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                name: _nameController.text,
                                city: _cityController.text,
                                country: _countryController.text,
                                accountNumber: _accountNumberController.text,
                                bankName: _bankNameController.text,
                                bankAddress: _bankAddressController.text,
                                swiftCode: _swiftCodeController.text,
                                ibanBsbAba: _ibanBsbAbaController.text,
                                branchName: '',
                                address: _bankAddressController.text,
                                isInternational: true,
                              );

                              await viewModel.addBeneficiary(
                                beneficiary,
                                viewModel.selectedCurrencyId!,
                              );

                              if (viewModel.error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${_nameController.text} added as beneficiary",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed: ${viewModel.error}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Save Beneficiary",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.primaryColor),
          floatingLabelBehavior: label == "Beneficiary's Full Name"
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          hintText: label == "Beneficiary's Full Name" ? "Enter full name as per bank records" : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<Map<String, dynamic>> items,
    void Function(dynamic) onChanged,
    ThemeData theme, {
    String labelKey = 'name',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: DropdownButtonFormField(
        isExpanded: true,
        value: label == "Currency" ? Provider.of<BeneficiaryProvider>(context, listen: false).selectedCurrencyId : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          labelText: label,
          labelStyle: TextStyle(color: theme.primaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
        dropdownColor: theme.cardColor,
        items: items.map((item) => DropdownMenuItem(
          value: item['_id'],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item[labelKey],
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
          ),
        )).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }
}
