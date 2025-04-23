// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/send_page_viewmodels/intermediary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIntermediaryScreen extends StatefulWidget {
  const AddIntermediaryScreen({super.key});

  @override
  State<AddIntermediaryScreen> createState() => _AddIntermediaryScreenState();
}

class _AddIntermediaryScreenState extends State<AddIntermediaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _bicCodeController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _sortCodeController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _bicCodeController.dispose();
    _bankAddressController.dispose();
    _sortCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intermediaryProvider = Provider.of<IntermediaryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Intermediary Bank",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body:
          intermediaryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildField("Bank Name", _bankNameController, theme),
                      _buildField("BIC/SWIFT Code", _bicCodeController, theme),
                      _buildField(
                        "Bank Address",
                        _bankAddressController,
                        theme,
                      ),
                      _buildField(
                        "Sort/BSB/ABA Code",
                        _sortCodeController,
                        theme,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await intermediaryProvider.createIntermediary(
                              intermediaryBankName:
                                  _bankNameController.text.trim(),
                              bicCode: _bicCodeController.text.trim(),
                              intermediaryBankAddress:
                                  _bankAddressController.text.trim(),
                              sortBsbAbaTransitFed:
                                  _sortCodeController.text.trim(),
                            );

                            if (intermediaryProvider.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error: ${intermediaryProvider.error}",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Intermediary added successfully",
                                  ),
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    ThemeData theme,
  ) {
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
        validator:
            (value) =>
                (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }
}
