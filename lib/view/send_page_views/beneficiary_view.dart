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
    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(
      context,
      listen: false,
    );

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Beneficiary's Full Name",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cityController,
                  label: "City",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _countryController,
                  label: "Country",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _accountNumberController,
                  label: "Account Number",
                  theme: theme,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankNameController,
                  label: "Bank Name",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankAddressController,
                  label: "Bank Address",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _swiftCodeController,
                  label: "SWIFT Code",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _ibanBsbAbaController,
                  label: "IBAN/BSB/ABA",
                  theme: theme,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final beneficiary = Beneficiary(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
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

                        await beneficiaryProvider.addBeneficiary(beneficiary);

                        if (beneficiaryProvider.error == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${_nameController.text} added as beneficiary",
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Failed to add beneficiary: ${beneficiaryProvider.error}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      keyboardType: keyboardType,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
