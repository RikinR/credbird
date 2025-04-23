import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/invoice_details_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/lrs_info_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/transaction_details_step_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';

class RemittanceFlow extends StatefulWidget {
  const RemittanceFlow({super.key});

  @override
  State<RemittanceFlow> createState() => _RemittanceFlowState();
}

class _RemittanceFlowState extends State<RemittanceFlow> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SendMoneyViewModel>(context, listen: false).loadDropdownData();
    });
  }

  @override
  Widget build(BuildContext context) {
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