import 'package:credbird/model/transaction_model.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/profile_views/kyc_screen_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/home_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme["cardBackground"],
                  backgroundImage: const AssetImage("assets/profile.png"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authViewModel.userName ?? "User",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      authViewModel.userEmail ?? "user@credbird.com",
                      style: TextStyle(
                        color: theme["secondaryText"],
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(context, Icons.person, "Account", () {
                    _showAccountDialog(context, authViewModel, theme);
                  }, theme),
                  _buildProfileOption(context, Icons.money, "KYC", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KYCView()),
                    );
                  }, theme),
                  _buildProfileOption(context, Icons.credit_card, "Cards", () {
                    _showCardsDialog(context, theme);
                  }, theme),
                  _buildProfileOption(
                    context,
                    Icons.history,
                    "Transactions",
                    () {
                      _showTransactionsDialog(context, homeViewModel, theme);
                    },
                    theme,
                  ),
                  _buildProfileOption(context, Icons.help, "Help", () {
                    homeViewModel.contactSupport(context);
                  }, theme),
                  _buildProfileOption(context, Icons.info, "About", () {
                    _showAboutDialog(context, theme);
                  }, theme),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["cardBackground"],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await authViewModel.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginSignupView(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: theme["negativeAmount"],
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
    Map<String, dynamic> theme,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme["buttonHighlight"]),
      title: Text(
        text,
        style: TextStyle(
          color: theme["textColor"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme["secondaryText"]),
      onTap: onTap,
    );
  }

  void _showAccountDialog(
    BuildContext context,
    AuthViewModel authViewModel,
    Map<String, dynamic> theme,
  ) {
    final nameController = TextEditingController(text: authViewModel.userName);
    final emailController = TextEditingController(
      text: authViewModel.userEmail,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme["cardBackground"],
            title: Text(
              "Edit Profile",
              style: TextStyle(
                color: theme["textColor"],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: theme["secondaryText"],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme["secondaryText"]!),
                    ),
                  ),
                  style: TextStyle(
                    color: theme["textColor"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: theme["secondaryText"],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme["secondaryText"]!),
                    ),
                  ),
                  style: TextStyle(
                    color: theme["textColor"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: theme["negativeAmount"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  authViewModel.updateProfile(
                    nameController.text,
                    emailController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully"),
                    ),
                  );
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: theme["positiveAmount"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showCardsDialog(BuildContext context, Map<String, dynamic> theme) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme["cardBackground"],
            title: Text(
              "Your Cards",
              style: TextStyle(
                color: theme["textColor"],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCardItem(
                    "Virtual Card •••• 4242",
                    "Expires 12/25",
                    Icons.credit_card,
                    theme,
                  ),
                  const SizedBox(height: 16),
                  _buildCardItem(
                    "Physical Card •••• 5689",
                    "Expires 08/24",
                    Icons.credit_card,
                    theme,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: theme["textColor"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCardItem(
    String title,
    String subtitle,
    IconData icon,
    Map<String, dynamic> theme,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme["buttonHighlight"], size: 40),
      title: Text(
        title,
        style: TextStyle(
          color: theme["textColor"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme["secondaryText"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Icon(Icons.more_vert, color: theme["secondaryText"]),
    );
  }

  void _showTransactionsDialog(
    BuildContext context,
    HomeViewModel homeViewModel,
    Map<String, dynamic> theme,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme["cardBackground"],
            title: Text(
              "Transaction History",
              style: TextStyle(
                color: theme["textColor"],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var transaction in homeViewModel.transactions)
                      _buildTransactionItem(transaction, theme),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: theme["textColor"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildTransactionItem(
    Transaction transaction,
    Map<String, dynamic> theme,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme["cardBackground"],
        child: Icon(
          transaction.isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
          color:
              transaction.isIncoming
                  ? theme["positiveAmount"]
                  : theme["negativeAmount"],
        ),
      ),
      title: Text(
        transaction.recipient,
        style: TextStyle(
          color: theme["textColor"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        transaction.date,
        style: TextStyle(
          color: theme["secondaryText"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Text(
        "\$${transaction.amount.toStringAsFixed(2)}",
        style: TextStyle(
          color:
              transaction.isIncoming
                  ? theme["positiveAmount"]
                  : theme["negativeAmount"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, Map<String, dynamic> theme) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme["cardBackground"],
            title: Text(
              "About CredBird",
              style: TextStyle(
                color: theme["textColor"],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "CredBird v1.0.0\n\nA modern banking app for all your financial needs.",
              style: TextStyle(
                color: theme["secondaryText"],
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: theme["textColor"],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
