// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:credbird/model/user_models/addtional_details.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';

class BusinessDetailsView extends StatefulWidget {
  const BusinessDetailsView({super.key});

  @override
  State<BusinessDetailsView> createState() => _BusinessDetailsViewState();
}

class _BusinessDetailsViewState extends State<BusinessDetailsView> {
  late TextEditingController _address;
  late TextEditingController _city;
  late TextEditingController _state;
  late TextEditingController _pin;
  late TextEditingController _country;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    _address = TextEditingController(text: auth.additionalDetails?.businessAddress);
    _city = TextEditingController(text: auth.additionalDetails?.businessCity);
    _state = TextEditingController(text: auth.additionalDetails?.businessState);
    _pin = TextEditingController(text: auth.additionalDetails?.businessPin);
    _country = TextEditingController(text: auth.additionalDetails?.businessCountry);

    if (auth.additionalDetails == null) {
      auth.fetchUserDetails();
    }
  }

  @override
  void dispose() {
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _pin.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
      ),
      backgroundColor: theme["scaffoldBackground"],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField("Business Address", _address, Icons.location_on, maxLines: 3),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("City", _city, Icons.location_city)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("State", _state, Icons.map)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("PIN Code", _pin, Icons.pin, inputType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("Country", _country, Icons.public)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      final details = AdditionalDetailsModel(
                        businessAddress: _address.text,
                        businessCity: _city.text,
                        businessState: _state.text,
                        businessPin: _pin.text,
                        businessCountry: _country.text,
                      );
                      await auth.updateAdditionalDetails(details);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Business details updated")),
                      );
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme["textColor"],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Save",
                style: TextStyle(color: theme["backgroundColor"], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme["textColor"]),
        filled: true,
        fillColor: theme["cardBackground"],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: theme["textColor"]),
    );
  }
}
