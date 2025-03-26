import 'package:credbird/model/beneficiray_models.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:flutter/material.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';

class AddBeneficiaryPage extends StatefulWidget {
  const AddBeneficiaryPage({super.key});

  @override
  State<AddBeneficiaryPage> createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _credBirdIdController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _credBirdIdController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: const Text(
          "Add Beneficiary",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
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
                  label: "Full Name",
                  theme: theme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _credBirdIdController,
                  label: "CredBird ID",
                  theme: theme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CredBird ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankAccountController,
                  label: "Bank Account Number (Optional)",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankNameController,
                  label: "Bank Name (Optional)",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _ifscCodeController,
                  label: "IFSC Code (Optional)",
                  theme: theme,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final beneficiary = Beneficiary(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          credBirdId: _credBirdIdController.text,
                          bankAccount:
                              _bankAccountController.text.isEmpty
                                  ? null
                                  : _bankAccountController.text,
                          bankName:
                              _bankNameController.text.isEmpty
                                  ? null
                                  : _bankNameController.text,
                          ifscCode:
                              _ifscCodeController.text.isEmpty
                                  ? null
                                  : _ifscCodeController.text,
                        );

                        beneficiaryProvider.addBeneficiary(beneficiary);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${_nameController.text} added as beneficiary",
                              style: TextStyle(color: theme["textColor"]),
                            ),
                            backgroundColor: theme["positiveAmount"],
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme["buttonHighlight"],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Save Beneficiary",
                      style: TextStyle(
                        color: theme["textColor"],
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
    required Map<String, dynamic> theme,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme["textColor"]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme["secondaryText"]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme["unhighlightedButton"]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme["unhighlightedButton"]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme["buttonHighlight"]!),
        ),
      ),
      validator: validator,
    );
  }
}
