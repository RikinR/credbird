import 'package:credbird/utils/send_page_utils.dart';
import 'package:credbird/view/send_page_views/remittance_view/initate_remittance_views/initate_remittance_flow_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/intermediary_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/invoices_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/add_remitter_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/beneficiary_view.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendPageView extends StatefulWidget {
  const SendPageView({super.key});

  @override
  State<SendPageView> createState() => _SendPageViewState();
}

class _SendPageViewState extends State<SendPageView> {
  @override
  void initState() {
    super.initState();
    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(
      context,
      listen: false,
    );
    beneficiaryProvider.fetchBeneficiaries();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<SendMoneyViewModel>(context);
    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(context);

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "Send Money",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
        actions: [
          _buildStyledButton(
            context,
            icon: Icons.add,
            label: "Add Beneficary",
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddBeneficiaryPage()),
                ),
            theme: theme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStyledButton(
                    context,
                    icon: Icons.paypal_rounded,
                    label: "See Invoices",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InvoiceListView(),
                          ),
                        ),
                    theme: theme,
                  ),
                  _buildStyledButton(
                    context,
                    icon: Icons.person_add,
                    label: "Add Remitter",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddRemitterScreen(),
                          ),
                        ),
                    theme: theme,
                  ),
                  _buildStyledButton(
                    context,
                    icon: Icons.account_balance,
                    label: "Add Intermediary",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddIntermediaryScreen(),
                          ),
                        ),
                    theme: theme,
                  ),
                  _buildStyledButton(
                    context,
                    icon: Icons.send,
                    label: "Remit Money",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RemittanceFlow(),
                          ),
                        ),
                    theme: theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBeneficiarySelector(context, beneficiaryProvider, theme),
                  const SizedBox(height: 12),
                  buildAmountInput(theme, viewModel),
                  const SizedBox(height: 12),
                  buildNumberPad(theme, viewModel),
                  const SizedBox(height: 16),
                  buildConfirmButton(context, theme, viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Map<String, dynamic> theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme["buttonHighlight"],
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: theme["backgroundColor"]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
