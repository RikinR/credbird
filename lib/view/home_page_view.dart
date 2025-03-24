import 'package:credbird/view/homePage%20components/account_card_view.dart';
import 'package:credbird/view/homePage%20components/tab_item_view.dart';
import 'package:credbird/viewmodel/home_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        backgroundColor: theme["scaffoldBackground"],
        elevation: 0,
        title: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Text(
              viewModel.isBalanceVisible ? "\$${viewModel.balance}" : "****",
              style: TextStyle(color: theme["buttonHighlight"], fontSize: 20),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: theme["buttonHighlight"]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  TabItem(title: "Send Money"),
                  TabItem(title: "Get Virtual Card"),
                  TabItem(title: "Pay2Remit"),
                  TabItem(title: "KYC"),
                  TabItem(title: "Forex Rate"),
                  TabItem(title: "Support"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome, ${viewModel.userName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          viewModel.isBalanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: viewModel.toggleBalanceVisibility,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const AccountCard(
              title: "Neo Credit",
              amount: "-\$20.99",
              cardNumber: "8907",
            ),
            const AccountCard(
              title: "Everyday Spending",
              amount: "\$0.00",
              cardNumber: "3114",
            ),
            const AccountCard(
              title: "High-Interest Savings",
              amount: "Hidden",
              cardNumber: "****",
            ),
            const AccountCard(
              title: "Neo Mortgage",
              amount: "Hidden",
              cardNumber: "****",
            ),
          ],
        ),
      ),
    );
  }
}
