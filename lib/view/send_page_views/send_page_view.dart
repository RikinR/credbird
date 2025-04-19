import 'package:credbird/utils/send_page_utils.dart';
import 'package:credbird/view/send_page_views/intermediary_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/add_remitter_view.dart';
import 'package:credbird/view/send_page_views/beneficiary_view.dart';
import 'package:credbird/view/send_page_views/remittance_view/initiate_remittance_view.dart';
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add Benefiicary',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text("Add Remitter"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddRemitterScreen(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.account_balance),
                    label: const Text("Add Intermediary"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddIntermediaryScreen(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Full Remittance Flow"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InitiateRemittanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBeneficiarySelector(context, beneficiaryProvider, theme),
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
