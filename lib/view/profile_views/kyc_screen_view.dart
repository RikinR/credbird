import 'package:credbird/viewmodel/profile_providers/kyc_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KYCView extends StatelessWidget {
  const KYCView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return ChangeNotifierProvider(
      create: (_) => KYCProvider(),
      child: Scaffold(
        backgroundColor: theme["scaffoldBackground"],
        appBar: AppBar(
          title: const Text("KYC Verification"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme["textColor"],
        ),
        body: const _KYCForm(),
      ),
    );
  }
}

class _KYCForm extends StatelessWidget {
  const _KYCForm();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final kycProvider = Provider.of<KYCProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Information",
              style: TextStyle(
                color: theme["textColor"],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "First Name",
              "Enter your first name",
              (value) => kycProvider.updateFirstName(value),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context,
              "Last Name",
              "Enter your last name",
              (value) => kycProvider.updateLastName(value),
            ),
            const SizedBox(height: 24),
            Text(
              "Bank Details",
              style: TextStyle(
                color: theme["textColor"],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              "Bank Name",
              "Enter your bank name",
              (value) => kycProvider.updateBankDetails(bankName: value),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context,
              "Account Number",
              "Enter your account number",
              (value) => kycProvider.updateBankDetails(accountNumber: value),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context,
              "IFSC Code",
              "Enter your bank's IFSC code",
              (value) => kycProvider.updateBankDetails(ifscCode: value),
            ),
            const SizedBox(height: 24),
            Text(
              "Identity Verification",
              style: TextStyle(
                color: theme["textColor"],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Upload a government-issued ID",
              style: TextStyle(color: theme["secondaryText"]),
            ),
            const SizedBox(height: 8),
            _buildDocumentUpload(context),
            const SizedBox(height: 24),
            if (kycProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  kycProvider.errorMessage!,
                  style: TextStyle(color: theme["negativeAmount"]),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    kycProvider.isLoading
                        ? null
                        : () => kycProvider.submitKYC(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["buttonHighlight"],

                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    kycProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Submit KYC",
                          style: TextStyle(
                            color: theme["textColor"],
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
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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

  Widget _buildDocumentUpload(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final kycProvider = Provider.of<KYCProvider>(context);

    return GestureDetector(
      onTap: () {
        _showDocumentTypePicker(context);
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme["cardBackground"],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme["secondaryText"]!.withOpacity(0.3)),
        ),
        child:
            kycProvider.kycData.documentPath == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 40,
                      color: theme["secondaryText"],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to upload document",
                      style: TextStyle(color: theme["secondaryText"]),
                    ),
                  ],
                )
                : Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.description,
                        size: 40,
                        color: theme["buttonHighlight"],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          kycProvider.kycData.documentType ?? "Document",
                          style: TextStyle(color: theme["secondaryText"]),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  void _showDocumentTypePicker(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final kycProvider = Provider.of<KYCProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme["cardBackground"],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Document Type",
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.credit_card,
                  color: theme["buttonHighlight"],
                ),
                title: Text(
                  "PAN Card",
                  style: TextStyle(color: theme["textColor"]),
                ),
                onTap: () {
                  kycProvider.updateDocument(
                    "/path/to/pan_card.pdf",
                    "PAN Card",
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.perm_identity,
                  color: theme["buttonHighlight"],
                ),
                title: Text(
                  "Aadhaar Card",
                  style: TextStyle(color: theme["textColor"]),
                ),
                onTap: () {
                  kycProvider.updateDocument(
                    "/path/to/aadhaar_card.pdf",
                    "Aadhaar Card",
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.drive_file_rename_outline,
                  color: theme["buttonHighlight"],
                ),
                title: Text(
                  "Passport",
                  style: TextStyle(color: theme["textColor"]),
                ),
                onTap: () {
                  kycProvider.updateDocument(
                    "/path/to/passport.pdf",
                    "Passport",
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: theme["negativeAmount"]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
