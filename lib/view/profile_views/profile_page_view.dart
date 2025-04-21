// ignore_for_file: use_build_context_synchronously

import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/profile_views/bank_detail_view.dart';
import 'package:credbird/view/profile_views/business_details_view.dart';
import 'package:credbird/view/profile_views/edit_account_view.dart';
import 'package:credbird/view/registration_views/gst_registration_view.dart';
import 'package:credbird/view/profile_views/kyc_view.dart';
import 'package:credbird/view/registration_views/registration_view.dart';
import 'package:credbird/view/profile_views/transaction_screen_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
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
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: theme["textColor"],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme["textColor"]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme["cardBackground"],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme["textColor"], width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: theme["cardBackground"],
                        backgroundImage: const AssetImage("assets/profile.png"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            homeViewModel.userName,
                            style: TextStyle(
                              color: theme["textColor"],
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authViewModel.userEmail ?? "user@credbird.com",
                            style: TextStyle(
                              color: theme["secondaryText"],
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: theme["cardBackground"],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      context,
                      Icons.person_outline,
                      "Account",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountEditView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildProfileOption(
                      context,
                      Icons.business_outlined,
                      "Business Details",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BusinessDetailsView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildProfileOption(
                      context,
                      Icons.account_balance,
                      "Update Bank Detail",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BankDetailsView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildProfileOption(
                      context,
                      Icons.account_balance_outlined,
                      "Registration",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildProfileOption(
                      context,
                      Icons.account_balance_outlined,
                      "GST Registration",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GstRegistrationView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildProfileOption(
                      context,
                      Icons.verified_user_outlined,
                      "KYC Verification",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KYCView(),
                          ),
                        );
                      },
                      theme,
                    ),
                    const Divider(height: 1, indent: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: theme["cardBackground"],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            context,
                            Icons.credit_card_outlined,
                            "Virtual Cards",
                            () {
                              _showCardsDialog(context, theme);
                            },
                            theme,
                          ),
                          const Divider(height: 1, indent: 16),
                          _buildProfileOption(
                            context,
                            Icons.history_outlined,
                            "Transaction History",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const TransactionHistoryView(),
                                ),
                              );
                            },
                            theme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: theme["cardBackground"],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            context,
                            Icons.help_outline,
                            "Help Center",
                            () {
                              homeViewModel.contactSupport(context);
                            },
                            theme,
                          ),
                          const Divider(height: 1, indent: 16),
                          _buildProfileOption(
                            context,
                            Icons.info_outline,
                            "About CredBird",
                            () {
                              _showAboutDialog(context, theme);
                            },
                            theme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme["cardBackground"],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: theme["negativeAmount"].withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),

                        onPressed: () async {
                          final loggedOut = await authViewModel.logout(context);
                          if (loggedOut) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginSignupView(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: theme["negativeAmount"],
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme["textColor"].withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme["textColor"], size: 20),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: theme["textColor"],
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme["secondaryText"]),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
    );
  }

  void _showCardsDialog(BuildContext context, Map<String, dynamic> theme) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: theme["cardBackground"],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Payment Methods",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme["backgroundColor"],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildCardItem(
                          "Virtual Card •••• 4242",
                          "Expires 12/25",
                          Icons.credit_card,
                          theme,
                        ),
                        const Divider(height: 1, indent: 16),
                        _buildCardItem(
                          "Physical Card •••• 5689",
                          "Expires 08/24",
                          Icons.credit_card,
                          theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: theme["textColor"],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme["textColor"].withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: theme["textColor"], size: 20),
      ),
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
        style: TextStyle(color: theme["secondaryText"], fontFamily: 'Roboto'),
      ),
      trailing: Icon(Icons.more_vert, color: theme["secondaryText"]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _showAboutDialog(BuildContext context, Map<String, dynamic> theme) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: theme["cardBackground"],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme["textColor"].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_outlined,
                      color: theme["textColor"],
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "CredBird",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "v1.0.0",
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "A modern banking app for all your financial needs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: theme["textColor"],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
