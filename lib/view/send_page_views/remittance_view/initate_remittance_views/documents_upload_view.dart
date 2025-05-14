// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:credbird/viewmodel/send_page_viewmodels/payment_viewmodel.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/document_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadDocumentsView extends StatefulWidget {
  final String transactionId;
  bool esign;

  UploadDocumentsView({
    super.key,
    required this.transactionId,
    required this.esign,
  });

  @override
  State<UploadDocumentsView> createState() => _UploadDocumentsViewState();
}

class _UploadDocumentsViewState extends State<UploadDocumentsView> {
  bool _consentGiven = false;
  late final DocumentViewModel _docVM;
  final Map<String, String> _uploadedUrlsMap = {};
  String? _eSignClientId;
  String? _eSignUrl;

  @override
  void initState() {
    super.initState();
    _docVM = Provider.of<DocumentViewModel>(context, listen: false);
    _docVM.fetchTransactionDocuments(widget.transactionId);
  }

  Future<void> _uploadPDF(String docId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      await _docVM.uploadFile(file);
      if (_docVM.uploadedFileUrls.isNotEmpty) {
        setState(() {
          _uploadedUrlsMap[docId] = _docVM.uploadedFileUrls.first;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Uploaded successfully for ${_getDocumentName(docId)}!",
            ),
          ),
        );
      }
    }
  }

  String _getDocumentName(String docId) {
    final doc = _docVM.requiredDocuments.firstWhere(
      (d) => d['id'] == docId,
      orElse: () => {'label': 'Document'},
    );
    return doc['label'];
  }

  Future<void> _submitDocuments() async {
    if (_docVM.requiredDocuments.isEmpty) return;

    final missingRequiredDocs =
        _docVM.requiredDocuments
            .where(
              (doc) =>
                  doc['required'] && !_uploadedUrlsMap.containsKey(doc['id']),
            )
            .toList();

    if (missingRequiredDocs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents.")),
      );
      return;
    }

    if (widget.esign && !_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please consent to e-sign terms.")),
      );
      return;
    }

    final documents =
        _docVM.requiredDocuments
            .map((doc) {
              final docId = doc['id'];
              final url = _uploadedUrlsMap[docId];
              return {
                "_id": docId,
                "documentUrl": url != null ? [url] : [],
              };
            })
            .where((d) => d['documentUrl']!.isNotEmpty)
            .toList();

    try {
      if (widget.esign) {
        await _docVM.submitDocuments(
          transactionId: widget.transactionId,
          documents: documents,
          isDraft: true,
        );

        final esignResponse = await _docVM.startESignProcess(
          transactionId: widget.transactionId,
          callBackUrl:
              "https://google.com", 
        );

        if (esignResponse['success'] == true) {
          setState(() {
            _eSignClientId = esignResponse['data']['client_id'];
            _eSignUrl = esignResponse['data']['url'];
            _docVM.setESignInProgress(true);
          });

          if (_eSignUrl != null) {
            if (await canLaunchUrl(Uri.parse(_eSignUrl!))) {
              await launchUrl(
                Uri.parse(_eSignUrl!),
                mode: LaunchMode.externalApplication,
              );
            } else {
              throw 'Could not launch $_eSignUrl';
            }
          }
        }
      } else {
        await _docVM.submitDocuments(
          transactionId: widget.transactionId,
          documents: documents,
          isDraft: false,
        );
        _startPaymentLinkFlow();
        _showValidationPopupAndNavigate();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _checkESignStatus() async {
    if (_eSignClientId == null) return;

    try {
      await _docVM.checkESignStatus(_eSignClientId!);

      if (_docVM.eSignStatus?['data'].toString().toLowerCase() ==
          "esign_completed") {
        final documents =
            _docVM.requiredDocuments
                .map((doc) {
                  final docId = doc['id'];
                  final url = _uploadedUrlsMap[docId];
                  print(
                    "Document ID: ${doc['id']} (Type: ${doc['id'].runtimeType})",
                  );

                  return {
                    "_id": docId,
                    "documentUrl": url != null ? [url] : [],
                  };
                })
                .where((d) => d['documentUrl']!.isNotEmpty)
                .toList();

        await _docVM.completeESignFlow(
          transactionId: widget.transactionId,
          documents: documents,
        );

        _startPaymentLinkFlow();
        _showValidationPopupAndNavigate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "E-Sign not completed yet. Please complete the process in the browser.",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error checking e-sign status: ${e.toString()}"),
        ),
      );
    }
  }

  void _showValidationPopupAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Please Wait"),
            content: const Text(
              "Validation is in progress. You will receive the payment link on your email shortly.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _startPaymentLinkFlow() async {
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    await paymentVM.startPayment(widget.transactionId);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/email.json', width: 150),
                const SizedBox(height: 16),
                const Text(
                  "We've emailed the payment link to your registered email.",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Documents")),
      body: Consumer<DocumentViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.requiredDocuments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme["buttonHighlight"],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await vm.downloadFormA2(widget.transactionId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Form A2 downloaded successfully."),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.download, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Download A2 Form",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme["backgroundColor"],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text("Use E-Sign"),
                  value: widget.esign,
                  onChanged:
                      vm.isESignInProgress
                          ? null
                          : (val) => setState(() => widget.esign = val),
                ),

                Expanded(
                  child:
                      vm.requiredDocuments.isEmpty
                          ? const Center(
                            child: Text(
                              "No documents required for this transaction",
                            ),
                          )
                          : ListView.builder(
                            itemCount: vm.requiredDocuments.length,
                            itemBuilder: (context, index) {
                              final doc = vm.requiredDocuments[index];
                              final isUploaded =
                                  doc['status'] == 'UPLOADED' ||
                                  _uploadedUrlsMap.containsKey(doc['id']);

                              return Card(
                                child: ListTile(
                                  title: Text(doc['label']),
                                  subtitle: Text(
                                    doc['required'] ? "Required" : "Optional",
                                    style: TextStyle(
                                      color:
                                          doc['required']
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isUploaded
                                          ? ElevatedButton.icon(
                                            onPressed: null,
                                            icon: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            label: const Text("Uploaded"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                          )
                                          : ElevatedButton.icon(
                                            onPressed:
                                                vm.isESignInProgress
                                                    ? null
                                                    : () =>
                                                        _uploadPDF(doc['id']),
                                            icon: const Icon(Icons.upload_file),
                                            label: const Text("Upload"),
                                          ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),

                if (widget.esign && !vm.isESignInProgress)
                  CheckboxListTile(
                    value: _consentGiven,
                    onChanged:
                        (val) => setState(() => _consentGiven = val ?? false),
                    title: const Text(
                      "I consent to the use of my Aadhar details for e-sign purposes.",
                    ),
                  ),
                const SizedBox(height: 16),

                _buildMainActionButton(vm, theme),

                if (vm.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      vm.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainActionButton(
    DocumentViewModel vm,
    Map<String, dynamic> theme,
  ) {
    if (vm.isESignInProgress) {
      return Column(
        children: [
          const Text(
            "Please complete the e-sign process in your browser",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _checkESignStatus,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Check E-Sign Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              if (_eSignUrl != null) {
                launchUrl(
                  Uri.parse(_eSignUrl!),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: const Text("Open E-Sign Page Again"),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme["buttonHighlight"],
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _submitDocuments,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.done, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              widget.esign ? "Start E-Sign Flow" : "Submit Documents",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme["backgroundColor"],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
