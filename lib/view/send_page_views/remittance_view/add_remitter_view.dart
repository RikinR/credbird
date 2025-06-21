// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/send_page_viewmodels/remitter_provider.dart';
import 'package:credbird/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AddRemitterScreen extends StatefulWidget {
  const AddRemitterScreen({super.key});

  @override
  State<AddRemitterScreen> createState() => _AddRemitterScreenState();
}

class _AddRemitterScreenState extends State<AddRemitterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController(text: "INDIA");
  final _pinController = TextEditingController();
  final _remitterTypeController = TextEditingController(text: 'Self');
  final _relationshipController = TextEditingController();
  final _travellerFullNameController = TextEditingController();
  final _passportNoController = TextEditingController();
  final _studentPlaceOfIssueController = TextEditingController();
  final _studentDateOfIssueController = TextEditingController();
  final _studentDateOfExpiryController = TextEditingController();
  final _studentAddressController = TextEditingController();
  final _remitterAddressProofController = TextEditingController();
  final _placeOfIssueController = TextEditingController();
  final _dateOfIssueController = TextEditingController();
  final _dateOfExpiryController = TextEditingController();

  @override
  void dispose() {
    _panController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinController.dispose();
    _relationshipController.dispose();
    _travellerFullNameController.dispose();
    _passportNoController.dispose();
    _studentPlaceOfIssueController.dispose();
    _studentDateOfIssueController.dispose();
    _studentDateOfExpiryController.dispose();
    _studentAddressController.dispose();
    _remitterAddressProofController.dispose();
    _placeOfIssueController.dispose();
    _dateOfIssueController.dispose();
    _dateOfExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remitterProvider = Provider.of<RemitterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Remitter",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body:
          remitterProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                          color: theme.cardColor,
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: ['Self', 'Guardian'].contains(_remitterTypeController.text) ? _remitterTypeController.text : 'Self',
                          items: ['Self', 'Guardian']
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: theme.textTheme.bodyLarge?.color,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _remitterTypeController.text = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            labelText: 'Remitter Type',
                            labelStyle: TextStyle(color: theme.primaryColor),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                          dropdownColor: theme.cardColor,
                        ),
                      ),
                      _buildField("PAN Number", _panController, theme,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                          LengthLimitingTextInputFormatter(10),
                          UpperCaseTextFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter PAN Number';
                          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}\$').hasMatch(value)) return 'Invalid PAN format';
                          return null;
                        },
                        textCapitalization: TextCapitalization.characters,
                      ),
                      if (remitterProvider.panName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "PAN Name: ${remitterProvider.panName}",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      _buildField("Account Number", _accountController, theme),
                      if (remitterProvider.accountHolderName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Account Holder Name: ${remitterProvider.accountHolderName}",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      _buildField("IFSC Code", _ifscController, theme),
                      _buildField("Email", _emailController, theme,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter Email';
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Invalid email';
                          return null;
                        },
                      ),
                      _buildField("Mobile", _mobileController, theme,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter Mobile';
                          if (value.length != 10) return 'Mobile must be 10 digits';
                          return null;
                        },
                      ),
                      _buildField("Address", _addressController, theme),
                      _buildField("City", _cityController, theme),
                      _buildField("State", _stateController, theme),
                      _buildField("Country", _countryController, theme, textCapitalization: TextCapitalization.characters),
                      _buildField("PIN", _pinController, theme,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter PIN';
                          if (value.length != 6) return 'PIN must be 6 digits';
                          return null;
                        },
                      ),

                      if (_remitterTypeController.text == 'Self') ...[
                        _buildField(
                          "Passport Number",
                          _remitterAddressProofController,
                          theme,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                            LengthLimitingTextInputFormatter(9),
                            UpperCaseTextFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter Passport Number';
                            if (!RegExp(r'^[A-Z0-9]{6,9}$').hasMatch(value)) return 'Invalid Passport Number';
                            return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                        ),
                        _buildField(
                          "Place of Issue",
                          _placeOfIssueController,
                          theme,
                        ),
                        _buildDateField(
                          "Date of Issue",
                          _dateOfIssueController,
                          theme,
                        ),
                        _buildDateField(
                          "Date of Expiry",
                          _dateOfExpiryController,
                          theme,
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DropdownButtonFormField<String>(
                            value: _relationshipController.text.isNotEmpty ? _relationshipController.text : null,
                            items: [
                              'MOTHER',
                              'FATHER',
                              'GUARDIAN',
                              'BROTHER',
                              'SISTER',
                              'SPOUSE',
                              'OTHER',
                            ].map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                )).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _relationshipController.text = newValue!;
                              });
                            },
                            decoration: _dropdownDecoration(theme, 'Relationship'),
                            validator: (value) => value == null || value.isEmpty ? 'Please select Relationship' : null,
                          ),
                        ),
                        _buildField(
                          "Traveler Full Name",
                          _travellerFullNameController,
                          theme,
                        ),
                        _buildField(
                          "Passport No",
                          _passportNoController,
                          theme,
                        ),
                        _buildField(
                          "Student Place of Issue",
                          _studentPlaceOfIssueController,
                          theme,
                        ),
                        _buildDateField(
                          "Student Date of Issue",
                          _studentDateOfIssueController,
                          theme,
                        ),
                        _buildDateField(
                          "Student Date of Expiry",
                          _studentDateOfExpiryController,
                          theme,
                        ),
                        _buildField(
                          "Student Address",
                          _studentAddressController,
                          theme,
                        ),
                        _buildField(
                          "Aadhaar Number",
                          _remitterAddressProofController,
                          theme,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter Aadhaar Number';
                            if (value.length != 16) return 'Aadhaar must be 16 digits';
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await remitterProvider.createRemitter(
                              remitterType: _remitterTypeController.text,
                              pan: _panController.text.trim(),
                              accountNumber: _accountController.text.trim(),
                              ifsc: _ifscController.text.trim(),
                              email: _emailController.text.trim(),
                              mobile: _mobileController.text.trim(),
                              address: _addressController.text.trim(),
                              city: _cityController.text.trim(),
                              state: _stateController.text.trim(),
                              country: _countryController.text.trim(),
                              pin: _pinController.text.trim(),
                              remitterAddressProof:
                                  _remitterAddressProofController.text.trim(),
                              placeOfIssue: _placeOfIssueController.text.trim(),
                              dateOfIssue: _dateOfIssueController.text.trim(),
                              dateOfExpiry: _dateOfExpiryController.text.trim(),
                              relationship: _relationshipController.text.trim(),
                              travellerFullName:
                                  _travellerFullNameController.text.trim(),
                              passportNo: _passportNoController.text.trim(),
                              studentPlaceOfIssue:
                                  _studentPlaceOfIssueController.text.trim(),
                              studentDateOfIssue:
                                  _studentDateOfIssueController.text.trim(),
                              studentDateOfExpiry:
                                  _studentDateOfExpiryController.text.trim(),
                              studentAddress:
                                  _studentAddressController.text.trim(),
                            );

                            if (remitterProvider.error != null) {
                              SnackBarUtils.showSnackBar(
                                context,
                                message: "Error: ${remitterProvider.error}",
                                isError: true,
                              );
                            } else {
                              SnackBarUtils.showSnackBar(
                                context,
                                message: "Remitter added successfully",
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
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
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text =
                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          final now = DateTime.now();
          final date = DateTime.tryParse(value);
          if (date == null) return 'Invalid date';
          if (label.contains('Issue') && date.isAfter(now)) {
            return 'Date of Issue cannot be in the future';
          }
          if (label.contains('Expiry') && date.isBefore(now)) {
            return 'Date of Expiry cannot be in the past';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    ThemeData theme,
    {List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.primaryColor),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        inputFormatters: inputFormatters,
        validator: validator,
        textCapitalization: textCapitalization,
      ),
    );
  }

  InputDecoration _dropdownDecoration(ThemeData theme, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.primaryColor),
      floatingLabelBehavior: label == 'Remitter Type' ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
      filled: true,
      fillColor: theme.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
