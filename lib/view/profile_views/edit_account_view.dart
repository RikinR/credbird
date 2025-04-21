// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';

import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AccountEditView extends StatelessWidget {
  const AccountEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: const Text("Edit Account"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
      ),
      body: const _AccountEditForm(),
    );
  }
}

class _AccountEditForm extends StatefulWidget {
  const _AccountEditForm();

  @override
  State<_AccountEditForm> createState() => _AccountEditFormState();
}

class _AccountEditFormState extends State<_AccountEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    _nameController = TextEditingController(text: homeViewModel.userName);
    _emailController = TextEditingController(text: homeViewModel.userEmail);
    _phoneController = TextEditingController(text: homeViewModel.userPhone);
    _addressController = TextEditingController(text: homeViewModel.userAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileImageSection(context, homeViewModel, theme),
            const SizedBox(height: 24),
            _buildTextField(
              context,
              "Full Name",
              "Enter your full name",
              _nameController,
              Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "Email",
              "Enter your email",
              _emailController,
              Icons.email,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "Phone Number",
              "Enter your phone number",
              _phoneController,
              Icons.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "Address",
              "Enter your address",
              _addressController,
              Icons.home,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            _buildSaveButton(context, homeViewModel, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    HomeViewModel homeViewModel,
    Map<String, dynamic> theme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            homeViewModel.isAccountLoading
                ? null
                : () async {
                  final authViewModel = Provider.of<AuthViewModel>(
                    context,
                    listen: false,
                  );
                  try {
                    await authViewModel.updateContactDetails(
                      name: _nameController.text,
                      email: _emailController.text,
                      mobile: _phoneController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact details updated successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error updating contact details: ${e.toString()}',
                        ),
                      ),
                    );
                  }
                },

        style: ElevatedButton.styleFrom(
          backgroundColor: theme["textColor"],
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            homeViewModel.isAccountLoading
                ? CircularProgressIndicator(color: theme["backgroundColor"])
                : Text(
                  "Save Changes",
                  style: TextStyle(
                    color: theme["backgroundColor"],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  Widget _buildProfileImageSection(
    BuildContext context,
    HomeViewModel homeViewModel,
    Map<String, dynamic> theme,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme["cardBackground"],
              backgroundImage:
                  homeViewModel.profileImagePath != null
                      ? FileImage(File(homeViewModel.profileImagePath!))
                      : const AssetImage("assets/profile.png") as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme["textColor"],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme["scaffoldBackground"],
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 20),
                  color: theme["backgroundColor"],
                  onPressed: () async {
                    await homeViewModel.pickAndUploadImage();
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Tap to change photo",
          style: TextStyle(color: theme["secondaryText"], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
