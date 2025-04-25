import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/invoice_details_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/lrs_info_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/transaction_details_step_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/profile_providers/kyc_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:credbird/view/profile_views/kyc_view.dart';

class RemittanceFlow extends StatefulWidget {
  const RemittanceFlow({super.key});

  @override
  State<RemittanceFlow> createState() => _RemittanceFlowState();
}

class _RemittanceFlowState extends State<RemittanceFlow> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  bool _kycCheckComplete = false;
  bool _kycVerified = false;

  @override
  void initState() {
    super.initState();
    _checkKYCStatus();
  }

  Future<void> _checkKYCStatus() async {
    final kycProvider = Provider.of<KYCProvider>(context, listen: false);
    await kycProvider.checkKYCStatus();
    setState(() {
      _kycVerified = kycProvider.isKYCDone;
      _kycCheckComplete = true;
    });

    if (_kycVerified) {
      Provider.of<SendMoneyViewModel>(context, listen: false).loadDropdownData();
    }
  }

  Widget _buildKYCPendingUI(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Remittance Transaction",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/kyc_animation.json', 
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                "KYC Verification Required",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Please complete your KYC verification to initiate remittance transactions.",
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KYCView(),
                      ),
                    ).then((_) => _checkKYCStatus());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                  )),
                  child: const Text(
                    "Complete KYC Now",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_kycCheckComplete) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_kycVerified) {
      return _buildKYCPendingUI(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Remittance Transaction",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            },
            steps: [
              Step(
                title: const Text('Transaction Details'),
                content: const SizedBox.shrink(),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('LRS Information'),
                content: const SizedBox.shrink(),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: const Text('Invoice Details'),
                content: const SizedBox.shrink(),
                isActive: _currentStep >= 2,
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TransactionDetailsStep(
                  onContinue: () {
                    setState(() {
                      _currentStep++;
                    });
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                LRSInformationStep(
                  onContinue: () {
                    setState(() {
                      _currentStep++;
                    });
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  onBack: () {
                    setState(() {
                      _currentStep--;
                    });
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                InvoiceDetailsStep(
                  onBack: () {
                    setState(() {
                      _currentStep--;
                    });
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}