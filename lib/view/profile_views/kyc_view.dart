import 'dart:io';
import 'package:credbird/view/initial_views/landing_page_view.dart';
import 'package:credbird/viewmodel/profile_providers/kyc_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:lottie/lottie.dart'; 

class KYCView extends StatefulWidget {
  const KYCView({super.key});

  @override
  State<KYCView> createState() => _KYCViewState();
}

class _KYCViewState extends State<KYCView> {
  String? registrationId;
  bool isSubmitted = false;
  bool _initialCheckComplete = false;
  @override
  void initState() {
    super.initState();
    _loadRegistrationId();
    _checkInitialKYCStatus();
  }

  Future<void> _loadRegistrationId() async {
    final prefs = await SharedPreferences.getInstance();
    final regId = prefs.getString('userId');

    if (regId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration ID not found')),
      );
      return;
    }

    setState(() {
      registrationId = regId;
    });

    await Provider.of<KYCProvider>(
      context,
      listen: false,
    ).loadPendingDocuments();
  }

  Future<void> _pickFile(String documentId) async {
    if (isSubmitted) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      Provider.of<KYCProvider>(
        context,
        listen: false,
      ).selectFile(documentId, file);
    }
  }

  Future<void> _checkInitialKYCStatus() async {
    await Provider.of<KYCProvider>(context, listen: false).checkKYCStatus();
    setState(() {
      _initialCheckComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) { final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final kycProvider = Provider.of<KYCProvider>(context);

    if (!_initialCheckComplete) {
      return Center(
        child: CircularProgressIndicator(color: theme["textColor"]),
      );
    }

    if (kycProvider.isKYCDone) {
      return Scaffold(
        backgroundColor: theme["scaffoldBackground"],
        appBar: AppBar(
          title: const Text("KYC Verification"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme["textColor"],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation.json', 
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                "KYC Verification Complete",
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["textColor"],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: theme["backgroundColor"],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: const Text("KYC Verification"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
        actions: [
          if (!isSubmitted)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingPageView(),
                  ),
                );
              },
              child: Text("Skip", style: TextStyle(color: theme["textColor"])),
            ),
        ],
      ),
      body:
          registrationId == null
              ? Center(
                child: CircularProgressIndicator(color: theme["textColor"]),
              )
              : kycProvider.isLoading
              ? Center(
                child: CircularProgressIndicator(color: theme["textColor"]),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: kycProvider.pendingDocs.length,
                        itemBuilder: (context, index) {
                          final doc = kycProvider.pendingDocs[index];
                          final documentId = doc['documentId']['_id'];
                          final docName = doc['documentId']['documentName'];
                          final selectedFile =
                              kycProvider.selectedFiles[documentId];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme["cardBackground"],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  docName,
                                  style: TextStyle(
                                    color: theme["textColor"],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedFile?.path.split('/').last ??
                                            "No file selected",
                                        style: TextStyle(
                                          color: theme["secondaryText"],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          isSubmitted
                                              ? null
                                              : () => _pickFile(documentId),
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(
                                          color:
                                              isSubmitted
                                                  ? Colors.grey
                                                  : theme["textColor"],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (kycProvider.isLoading || isSubmitted)
                                ? null
                                : () async {
                                  await kycProvider.uploadAllDocuments(
                                    registrationId!,
                                  );
                                  setState(() {
                                    isSubmitted = true;
                                  });
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme["textColor"],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Submit Documents",
                          style: TextStyle(
                            color: theme["backgroundColor"],
                            fontSize: 16,
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
}
