// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/send_page_viewmodels/remitter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: remitterProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildField("PAN Number", _panController, theme),
                    _buildField("Account Number", _accountController, theme),
                    _buildField("IFSC Code", _ifscController, theme),
                    _buildField("Email", _emailController, theme),
                    _buildField("Mobile", _mobileController, theme),
                    _buildField("Address", _addressController, theme),
                    _buildField("City", _cityController, theme),
                    _buildField("State", _stateController, theme),
                    _buildField("Country", _countryController, theme),
                    _buildField("PIN", _pinController, theme),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                      )),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await remitterProvider.createRemitter(
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
                          );

                          if (remitterProvider.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: ${remitterProvider.error}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Remitter added successfully"),
                                backgroundColor: Colors.green,
                              ),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
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
        validator: (value) => (value == null || value.isEmpty)
            ? 'Please enter $label'
            : null,
      ),
    );
  }
}