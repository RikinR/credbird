import 'package:credbird/utils/send_page_utils.dart';
import 'package:credbird/viewmodel/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendPageView extends StatelessWidget {
  const SendPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Money"),
        backgroundColor: theme["scaffoldBackground"],
        foregroundColor: theme["textColor"],
      ),
      backgroundColor: theme["scaffoldBackground"],
      body: Consumer<SendMoneyViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Contacts",
                  style: TextStyle(color: theme["textColor"], fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...viewModel.recentContacts.map((contact) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showConfirmationDialog(
                                  context,
                                  viewModel,
                                  contact,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),
                                child: Center(
                                  child: Text(
                                    contact[0],
                                    style: TextStyle(
                                      color: theme["textColor"],
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              contact,
                              style: TextStyle(
                                color: theme["textColor"],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          showAddRecipientDialog(context, viewModel);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[600],
                              ),
                              child: Icon(
                                Icons.add,
                                color: theme["textColor"],
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Add",
                              style: TextStyle(
                                color: theme["textColor"],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: viewModel.amountController,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixText: "\$",
                    prefixStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    viewModel.updateAmount(double.tryParse(value) ?? 0.0);
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      if (viewModel.amount > 0) {
                        showConfirmationDialog(
                          context,
                          viewModel,
                          viewModel.recentContacts.first,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid amount"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Send Money",
                      style: TextStyle(fontSize: 18, color: theme["textColor"]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Transaction History",
                  style: TextStyle(color: theme["textColor"], fontSize: 18),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      viewModel.transactionHistory.isEmpty
                          ? const Center(
                            child: Text(
                              "No transactions yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                          : ListView.builder(
                            itemCount: viewModel.transactionHistory.length,
                            itemBuilder: (context, index) {
                              final transaction =
                                  viewModel.transactionHistory[index];
                              return ListTile(
                                leading: const Icon(
                                  Icons.monetization_on,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  "Sent ${transaction["amount"]} to ${transaction["recipient"]}",
                                  style: TextStyle(color: theme["textColor"]),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
