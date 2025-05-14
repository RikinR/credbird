// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:credbird/viewmodel/send_page_viewmodels/payment_viewmodel.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentLinkScreen extends StatelessWidget {
  final String transactionId;
  final String status;

  const PaymentLinkScreen({
    super.key,
    required this.transactionId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final lowerStatus = status.toLowerCase();
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Transaction Status')),
        body: Center(
          child:
              lowerStatus == 'pending'
                  ? _buildPendingUI()
                  : _buildVerifiedUI(context),
        ),
      ),
    );
  }

  Widget _buildPendingUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: Lottie.asset('assets/animations/waiting_verification.json'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your transaction is pending verification.\nPlease wait...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildVerifiedUI(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        return vm.isLoading
            ? const CircularProgressIndicator()
            : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  child: Lottie.asset('assets/animations/send_email.json'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Send a payment link to the user\'s email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
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
                  child: const Text(
                    'Get Payment Link!',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed:
                      vm.linkSent
                          ? null 
                          : () async {
                            try {
                              await vm.startPayment(transactionId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "You will receive payment link on your mail shortly!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                ),
              ],
            );
      },
    );
  }
}
