// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:credbird/model/transaction_model.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/card_view.dart';
import 'package:credbird/view/home_page_views/forex_rates_view.dart';
import 'package:credbird/view/home_page_views/international_tourist_view.dart';
import 'package:credbird/view/receive_page_view.dart';
import 'package:credbird/view/send_page_views/send_page_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/international_tourist_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme["scaffoldBackground"],
        drawer: _buildDrawer(context, theme, homeViewModel, authViewModel),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: theme["textColor"]),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance",
                style: TextStyle(
                  color: theme["secondaryText"],
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                homeViewModel.isBalanceVisible
                    ? "\$${homeViewModel.balance.toStringAsFixed(2)}"
                    : "****",
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 28,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: FaIcon(
                homeViewModel.isBalanceVisible
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: theme["textColor"],
                size: 20,
              ),
              onPressed: homeViewModel.toggleBalanceVisibility,
            ),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.bell,
                color: theme["textColor"],
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Divider(thickness: 1, height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildActionButton(
                                context,
                                "Request",
                                FontAwesomeIcons.handHoldingDollar,
                                theme,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChangeNotifierProvider(
                                            create:
                                                (_) => ReceiveMoneyViewModel(),
                                            child: const ReceivePageView(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Send Money Abroad",
                                FontAwesomeIcons.paperPlane,
                                theme,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChangeNotifierProvider(
                                            create: (_) => SendMoneyViewModel(),
                                            child: const SendPageView(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Virtual Card",
                                FontAwesomeIcons.creditCard,
                                theme,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChangeNotifierProvider(
                                            create: (_) => CardViewModel(),
                                            child: const CardView(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildActionButton(
                                context,
                                "International Tourist",
                                FontAwesomeIcons.earthAsia,
                                theme,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChangeNotifierProvider(
                                            create:
                                                (_) =>
                                                    InternationalTouristViewModel(),
                                            child:
                                                const InternationalTouristView(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Forex Rates",
                                FontAwesomeIcons.chartLine,
                                theme,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChangeNotifierProvider(
                                            create:
                                                (_) => ForexRatesViewModel(),
                                            child: const ForexRatesView(),
                                          ),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Support",
                                FontAwesomeIcons.headset,
                                theme,
                                onPressed:
                                    () => homeViewModel.contactSupport(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                color: theme["textColor"],
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...homeViewModel.transactions.map(
                              (transaction) =>
                                  _buildTransactionItem(transaction, theme),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    Map<String, dynamic> theme,
    HomeViewModel homeViewModel,
    AuthViewModel authViewModel,
  ) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme["backgroundColor"]),

              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme["textColor"],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: theme["textColor"],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authViewModel.userName ?? "User",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authViewModel.userEmail ?? "user@credbird.com",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.home,
                    "Home",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.credit_card,
                    "Cards",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider(
                                create: (_) => CardViewModel(),
                                child: const CardView(),
                              ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.history,
                    "Transaction History",
                    onTap: () {
                      Navigator.pop(context);
                      homeViewModel.showTransactionHistory(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.help_outline,
                    "Help & Support",
                    onTap: () {
                      Navigator.pop(context);
                      homeViewModel.contactSupport(context);
                    },
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    context,
                    Icons.logout,
                    "Logout",
                    onTap: () async {
                      Navigator.pop(context);
                      await authViewModel.logout(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginSignupView(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return ListTile(
      leading: Icon(icon, color: theme["textColor"]),
      title: Text(
        title,
        style: TextStyle(
          color: theme["textColor"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Map<String, dynamic> theme, {
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          height: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme["buttonBackground"],
              foregroundColor: theme["textColor"],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            ),
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon, size: 16),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme["textColor"],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    Transaction transaction,
    Map<String, dynamic> theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme["cardBackground"],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    transaction.isIncoming
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
              ),
              child: Icon(
                transaction.isIncoming
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: transaction.isIncoming ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.recipient,
                    style: TextStyle(
                      color: theme["textColor"],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${transaction.isIncoming ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.isIncoming ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
