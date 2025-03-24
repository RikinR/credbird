import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivePageView extends StatelessWidget {
  const ReceivePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive Money"),
        backgroundColor: theme["scaffoldBackground"],
        foregroundColor: theme["textColor"],
      ),
      backgroundColor: theme["scaffoldBackground"],
      body: Consumer<ReceiveMoneyViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Request Money From",
                  style: TextStyle(color: theme["textColor"], fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        viewModel.contacts.map((contact) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  viewModel.requestMoney(context, contact);
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
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: viewModel.amountController,
                  style: TextStyle(color: theme["textColor"], fontSize: 24),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixText: "\$",
                    prefixStyle: TextStyle(
                      color: theme["textColor"],
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
                        viewModel.requestMoney(
                          context,
                          viewModel.contacts.first,
                        );
                      }
                    },
                    child: Text(
                      "Request Money",
                      style: TextStyle(fontSize: 18, color: theme["textColor"]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.qr_code,
                      color: theme["textColor"],
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Received History",
                  style: TextStyle(color: theme["textColor"], fontSize: 18),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.receivedHistory.length,
                    itemBuilder: (context, index) {
                      final transaction = viewModel.receivedHistory[index];
                      return ListTile(
                        title: Text(
                          transaction["sender"]!,
                          style: TextStyle(color: theme["textColor"]),
                        ),
                        subtitle: Text(
                          transaction["amount"]!,
                          style: const TextStyle(color: Colors.greenAccent),
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
