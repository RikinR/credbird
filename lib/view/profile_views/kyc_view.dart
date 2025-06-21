// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:credbird/view/initial_views/landing_page_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
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
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.fetchUserDetails();
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

  Future<void> _checkInitialKYCStatus() async {
    await Provider.of<KYCProvider>(context, listen: false).checkKYCStatus();
    setState(() {
      _initialCheckComplete = true;
    });
  }

  Future<void> _pickFile(String documentId) async {
    if (isSubmitted) return;

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitDocuments() async {
    if (registrationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration ID not found')),
      );
      return;
    }

    setState(() {
      isSubmitted = true;
    });

    try {
      await Provider.of<KYCProvider>(context, listen: false)
          .uploadAllDocuments(registrationId!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Wait for a short delay to show the success message
        await Future.delayed(const Duration(seconds: 2));
        
        // Navigate back or to next screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LandingPageView(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSubmitted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading documents: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<KYCProvider>(
      builder: (context, kycProvider, child) {
        if (kycProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        bool documentsUploaded = kycProvider.hasUploadedDocuments;
        bool documentsVerified = kycProvider.hasVerifiedDocuments;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'KYC Verification',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: theme.primaryColor),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (documentsUploaded && !documentsVerified)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.pending_outlined,
                            color: theme.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Documents Under Review',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your documents have been uploaded and are pending verification. This process may take some time.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (!documentsUploaded && !documentsVerified)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KYC Documents Required',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please upload the following documents to complete your KYC verification.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docName,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedFile?.path.split('/').last ??
                                                "No file selected",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              isSubmitted
                                                  ? null
                                                  : () => _pickFile(documentId),
                                          child: Text(
                                            "Choose File",
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: isSubmitted ? Colors.grey : theme.primaryColor,
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
                      ],
                    ),

                  if (documentsUploaded || documentsVerified)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Uploaded Documents',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: kycProvider.pendingDocs.length,
                          itemBuilder: (context, index) {
                            final doc = kycProvider.pendingDocs[index];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                title: Text(
                                  doc['documentId']['documentName'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Status: ${doc['status']}',
                                    style: TextStyle(
                                      color: doc['status'] == "VERIFIED"
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  doc['status'] == "VERIFIED"
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  color: doc['status'] == "VERIFIED"
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 28,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKYCCompletedScreen(Map<String, dynamic> theme) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                "Continue",
                style: TextStyle(color: theme["backgroundColor"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKYCInProgressScreen(Map<String, dynamic> theme) {
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
              'assets/processing.json',
              width: 200,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 20),
            Text(
              "KYC Verification In Progress",
              style: TextStyle(
                color: theme["textColor"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Please wait while we validate your documents.",
              style: TextStyle(color: theme["secondaryText"], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
