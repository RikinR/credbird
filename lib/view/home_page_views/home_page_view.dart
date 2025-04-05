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
  String? _selectedRecipientName;
  String? _selectedActionButton;

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
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: theme["textColor"]),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Balance",
              //   style: TextStyle(
              //     color: theme["secondaryText"],
              //     fontSize: 14,
              //     fontFamily: 'Roboto',
              //     fontWeight: FontWeight.w300,
              //   ),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   homeViewModel.isBalanceVisible
              //       ? "\$${homeViewModel.balance.toStringAsFixed(2)}"
              //       : "****",
              //   style: TextStyle(
              //     color: theme["textColor"],
              //     fontSize: 28,
              //     fontFamily: 'Roboto',
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Divider(thickness: 1, height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Send Money",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Option",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
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
                                      (_) => InternationalTouristViewModel(),
                                  child: const InternationalTouristView(),
                                ),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      "Forex",
                      FontAwesomeIcons.chartLine,
                      theme,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChangeNotifierProvider(
                                  create: (_) => ForexRatesViewModel(),
                                  child: const ForexRatesView(),
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: theme["cardBackground"],
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Row(
                        children: [
                          Text(
                            "Recent Recipients",
                            style: TextStyle(
                              color: theme["textColor"],
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          _buildRecipientItem(
                            "https://randomuser.me/api/portraits/men/32.jpg",
                            "John Doe",
                            theme,
                            onTap: () {},
                          ),
                          _buildRecipientItem(
                            "https://randomuser.me/api/portraits/women/44.jpg",
                            "Sarah Kim",
                            theme,
                            onTap: () {},
                          ),
                          _buildRecipientItem(
                            "https://randomuser.me/api/portraits/men/55.jpg",
                            "Mike Ross",
                            theme,
                            onTap: () {},
                          ),
                          _buildRecipientItem(
                            "https://randomuser.me/api/portraits/women/67.jpg",
                            "Emma Watson",
                            theme,
                            onTap: () {},
                          ),
                        ],
                      ),
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
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Text(
                        "Add New Contact",
                        style: TextStyle(
                          color: theme["textColor"],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        style: TextStyle(color: theme["textColor"]),
                        decoration: InputDecoration(
                          hintText: "Search contacts...",
                          hintStyle: TextStyle(
                            color: theme["textColor"]?.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme["textColor"]?.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: theme["buttonBackground"],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          _buildContactItem(
                            "https://randomuser.me/api/portraits/men/92.jpg",
                            "Robert Fox",
                            "+1 234 567 890",
                            false,
                            theme,
                          ),
                          _buildContactItem(
                            "https://randomuser.me/api/portraits/women/72.jpg",
                            "Jenny Wilson",
                            "+1 345 678 901",
                            true,
                            theme,
                          ),
                          _buildContactItem(
                            "https://randomuser.me/api/portraits/men/45.jpg",
                            "Jacob Jones",
                            "+1 456 789 012",
                            false,
                            theme,
                          ),
                          _buildContactItem(
                            "https://randomuser.me/api/portraits/women/28.jpg",
                            "Esther Howard",
                            "+1 567 890 123",
                            true,
                            theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transactions",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 18,
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
              const SizedBox(height: 16),
            ],
          ),
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
    final bool isSelected = _selectedActionButton == label;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          height: 100,
          width: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected
                      ? theme["buttonHighlight"]
                      : theme["buttonBackground"],
              foregroundColor: isSelected ? Colors.white : theme["textColor"],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            ),
            onPressed: () {
              setState(() => _selectedActionButton = label);
              onPressed();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon, size: 20),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : theme["textColor"],
                      height: 1.1,
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

  Widget _buildRecipientItem(
    String imageUrl,
    String name,
    Map<String, dynamic> theme, {
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedRecipientName == name;
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _selectedRecipientName = name);
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: theme["glassEffect"],
          highlightColor: theme["glassEffect"],
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? Colors.grey[500]
                            : theme["textColor"]?.withOpacity(0.1) ??
                                Colors.grey,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme["textColor"],
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 25,
                        color: theme["textColor"],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    String imageUrl,
    String name,
    String phone,
    bool isInvited,
    Map<String, dynamic> theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme["textColor"]?.withOpacity(0.1) ?? Colors.grey,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.person, color: theme["textColor"]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      phone,
                      style: TextStyle(
                        color: theme["textColor"]?.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isInvited
                          ? theme["glassEffect"]
                          : theme["unhighlightedButton"],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 24), // Set minimum size
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Reduce tap target
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    isInvited ? "Invited" : "Invite",
                    style: TextStyle(
                      color:
                          isInvited
                              ? theme["textColor"]?.withOpacity(0.8)
                              : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme["textColor"]?.withOpacity(0.1) ?? Colors.grey,
            height: 8,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
