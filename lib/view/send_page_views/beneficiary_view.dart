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
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _swiftCodeController = TextEditingController();
  final _ibanController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _transferLimitController = TextEditingController();
  bool _isInternational = false;

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _ifscCodeController.dispose();
    _swiftCodeController.dispose();
    _ibanController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _transferLimitController.dispose();
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
                Row(
                  children: [
                    Text(
                      "International Beneficiary",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _isInternational,
                      onChanged: (value) {
                        setState(() {
                          _isInternational = value;
                        });
                      },
                      activeColor: theme["buttonHighlight"],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nameController,
                  label: "Beneficiary's Full Name",
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
                  controller: _accountNumberController,
                  label: _isInternational ? "Account Number/IBAN" : "Bank Account Number",
                  theme: theme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    return null;
                  },
                ),
                if (!_isInternational) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _ifscCodeController,
                    label: "IFSC Code",
                    theme: theme,
                    validator: (value) {
                      if (!_isInternational && (value == null || value.isEmpty)) {
                        return 'Please enter IFSC code';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankNameController,
                  label: "Bank Name",
                  theme: theme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bank name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _branchNameController,
                  label: "Branch Name",
                  theme: theme,
                  validator: (value) {
                    if (!_isInternational && (value == null || value.isEmpty)) {
                      return 'Please enter branch name';
                    }
                    return null;
                  },
                ),
                if (_isInternational) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _swiftCodeController,
                    label: "SWIFT/BIC Code",
                    theme: theme,
                    validator: (value) {
                      if (_isInternational && (value == null || value.isEmpty)) {
                        return 'Please enter SWIFT code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _ibanController,
                    label: "IBAN (if different from account number)",
                    theme: theme,
                  ),
                ],
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: "Address (Optional)",
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _mobileNumberController,
                  label: "Mobile Number (Optional)",
                  theme: theme,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: "Email (Optional)",
                  theme: theme,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _transferLimitController,
                  label: "Transfer Limit (Optional)",
                  theme: theme,
                  keyboardType: TextInputType.number,
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
                          accountNumber: _accountNumberController.text,
                          bankName: _bankNameController.text,
                          branchName: _branchNameController.text,
                          ifscCode: _isInternational ? null : _ifscCodeController.text,
                          swiftCode: _isInternational ? _swiftCodeController.text : null,
                          iban: _isInternational ? _ibanController.text : null,
                          address: _addressController.text.isEmpty ? null : _addressController.text,
                          mobileNumber: _mobileNumberController.text.isEmpty ? null : _mobileNumberController.text,
                          email: _emailController.text.isEmpty ? null : _emailController.text,
                          transferLimit: _transferLimitController.text.isEmpty
                              ? null
                              : double.tryParse(_transferLimitController.text),
                          isInternational: _isInternational,
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme["textColor"]),
      keyboardType: keyboardType,
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