// ignore_for_file: use_build_context_synchronously

import 'package:credbird/utils/receive_page_utils.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';

class ReceivePageView extends StatelessWidget {
  const ReceivePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<ReceiveMoneyViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme["scaffoldBackground"],
        appBar: AppBar(
          title: Text(
            "Receive & Expenses",
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme["textColor"],
          bottom: TabBar(
            indicatorColor: theme["textColor"],
            labelColor: theme["textColor"],
            unselectedLabelColor: theme["secondaryText"],
            tabs: const [
              Tab(text: "Request Money"),
              Tab(text: "Monitor Expenses"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestMoneyTab(context, theme, viewModel),
            _buildMonitorExpensesTab(context, theme, homeViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestMoneyTab(
    BuildContext context,
    Map<String, dynamic> theme,
    ReceiveMoneyViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Request Money From",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (viewModel.selectedContact != null)
                      TextButton(
                        onPressed: () {
                          viewModel.selectContact(viewModel.selectedContact!);
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            color: theme["textColor"],
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...viewModel.contacts.map((contact) {
                        return buildContactItem(
                          contact,
                          theme,
                          viewModel.selectedContact == contact,
                          () {
                            viewModel.selectContact(contact);
                          },
                        );
                      }),
                      buildAddContactButton(context, theme),
                    ],
                  ),
                ),
                if (viewModel.selectedContact != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    "Amount to Request",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: viewModel.amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: theme["textColor"],
                      ),
                    ),
                    style: TextStyle(
                      color: theme["textColor"],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme["textColor"],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final amount =
                            double.tryParse(viewModel.amountController.text) ??
                            0.0;
                        viewModel.updateAmount(amount);
                        viewModel.requestMoney(context);
                      },
                      child: Text(
                        "Request Money",
                        style: TextStyle(
                          color: theme["scaffoldBackground"],
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => showQRCodeDialog(context, viewModel.userId),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme["cardBackground"],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.qr_code,
                        size: 100,
                        color: theme["textColor"],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Your CredBird ID",
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.userId,
                        style: TextStyle(
                          color: theme["textColor"],
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.copy, color: theme["textColor"]),
                        onPressed: () {
                          FlutterClipboard.copy(viewModel.userId).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("ID copied to clipboard"),
                              ),
                            );
                          });
                        },
                      ),
                      Text(
                        "Copy ID",
                        style: TextStyle(
                          color: theme["textColor"],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme["textColor"],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Share.share(
                      "Send me money on CredBird using my ID: ${viewModel.userId}",
                      subject: "CredBird Payment Request",
                    );
                  },
                  child: Text(
                    "Share Your ID",
                    style: TextStyle(
                      color: theme["backgroundColor"],
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitorExpensesTab(
    BuildContext context,
    Map<String, dynamic> theme,
    HomeViewModel homeViewModel,
  ) {
    final outgoingTransactions =
        homeViewModel.transactions.where((t) => !t.isIncoming).toList();

    final totalExpenses = outgoingTransactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Expenses",
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '-\$${totalExpenses.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (outgoingTransactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No expenses to display",
              style: TextStyle(
                color: theme["secondaryText"],
                fontFamily: 'Roboto',
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: outgoingTransactions.length,
              itemBuilder: (context, index) {
                final transaction = outgoingTransactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: theme["cardBackground"],
                  child: ListTile(
                    leading: Icon(Icons.arrow_upward, color: Colors.red),
                    title: Text(
                      transaction.recipient,
                      style: TextStyle(
                        color: theme["textColor"],
                        fontFamily: 'Roboto',
                      ),
                    ),
                    subtitle: Text(
                      transaction.date,
                      style: TextStyle(
                        color: theme["secondaryText"],
                        fontFamily: 'Roboto',
                      ),
                    ),
                    trailing: Text(
                      '-\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
