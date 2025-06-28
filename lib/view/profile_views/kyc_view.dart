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
    _initialCheckComplete = false;
    _initializeKYC();
  }

  Future<void> _initializeKYC() async {
    await _loadRegistrationId();
    await _checkInitialKYCStatus();
    setState(() {
      _initialCheckComplete = true;
    });
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
    await Provider.of<KYCProvider>(context, listen: false).loadPendingDocuments();
  }

  Future<void> _checkInitialKYCStatus() async {
    await Provider.of<KYCProvider>(context, listen: false).checkKYCStatus();
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
        Provider.of<KYCProvider>(context, listen: false).selectFile(documentId, file);
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
    setState(() { isSubmitted = true; });
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
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() { isSubmitted = false; });
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
    return Consumer<KYCProvider>(
      builder: (context, kycProvider, child) {
        if (!_initialCheckComplete || kycProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final theme = Theme.of(context);
        final needsToUpload = kycProvider.needsToUpload;
        final isUnderReview = kycProvider.isUnderReview;
        final isKYCComplete = kycProvider.isKYCComplete;
        return Scaffold(
          appBar: AppBar(
            title: const Text('KYC Verification'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (needsToUpload)
                ...[
                  Text(
                    'KYC Documents Required',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please upload the following documents to complete your KYC verification.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ...kycProvider.pendingDocs.map((doc) {
                    final documentId = doc['documentId']['_id'];
                    final docName = doc['documentId']['documentName'];
                    final selectedFile = kycProvider.selectedFiles[documentId];
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
                          Text(docName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                selectedFile?.path.split('/').last ?? "No file selected",
                                style: theme.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: isSubmitted ? null : () => _pickFile(documentId),
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
                  }).toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitted ? null : _submitDocuments,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSubmitted
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit Documents", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              if (isUnderReview)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.pending_outlined, color: theme.primaryColor, size: 32),
                      const SizedBox(height: 12),
                      Text('Documents Under Review', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                      const SizedBox(height: 8),
                      Text(
                        'Your documents have been uploaded and are pending verification. This process may take some time.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              if (isKYCComplete)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Uploaded Documents', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ...kycProvider.pendingDocs.map((doc) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(doc['documentId']['documentName'], style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Status: ${doc['status']}',
                              style: TextStyle(
                                color: doc['status'] == "VERIFIED" ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            doc['status'] == "VERIFIED" ? Icons.check_circle : Icons.pending,
                            color: doc['status'] == "VERIFIED" ? Colors.green : Colors.orange,
                            size: 28,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              if (!needsToUpload && !isUnderReview && !isKYCComplete)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Text(
                    "No KYC documents required or all documents are verified.",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
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
