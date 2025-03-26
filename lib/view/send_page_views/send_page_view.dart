import 'package:credbird/utils/send_page_utils.dart';
import 'package:credbird/view/send_page_views/beneficiary_view.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendPageView extends StatelessWidget {
  const SendPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<SendMoneyViewModel>(context);

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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBeneficiaryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          children: [
            buildPaymentMethodSelector(context, theme, viewModel),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.paymentMethod == PaymentMethod.contact) ...[
                    buildContactSelector(theme, viewModel, context),
                  ] else ...[
                    buildCredBirdIdInput(theme, viewModel),
                  ],
                  buildAmountInput(theme, viewModel),
                  buildNumberPad(theme, viewModel),
                  buildConfirmButton(context, theme, viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
