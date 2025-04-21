// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:credbird/model/remittance/transaction_model.dart';
import 'package:credbird/model/user_models/dashboard_count.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/initial_views/card_view.dart';
import 'package:credbird/view/home_page_views/forex_rates_view.dart';
import 'package:credbird/view/home_page_views/international_tourist_view.dart';
import 'package:credbird/view/profile_views/profile_page_view.dart';
import 'package:credbird/view/send_page_views/send_page_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/dashboard_viewmodel.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/international_tourist_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _appBarController;
  final int _profileImageNumber = DateTime.now().microsecond % 100;
  String? _selectedRecipientName;
  String? _selectedActionButton;

  @override
  void initState() {
    super.initState();
    _appBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 0,
    );

    _scrollController.addListener(() {
      if (!mounted) return;
      final scrollPosition = _scrollController.position.pixels;
      final maxScroll = MediaQuery.of(context).size.height * 0.15;
      final targetOpacity = (scrollPosition / maxScroll).clamp(0.0, 1.0);
      _appBarController.animateTo(targetOpacity);
    });
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    authViewModel.fetchUserDetails();
  }

  @override
  void dispose() {
    _appBarController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: theme["scaffoldBackground"],
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(context, theme, homeViewModel, authViewModel),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarController,
          builder: (context, value, child) {
            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: value * 15,
                  sigmaY: value * 15,
                ),
                child: Container(
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  decoration: BoxDecoration(
                    color: theme["cardBackground"]?.withOpacity(value * 0.5),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(value * 0.1),
                        Colors.white.withOpacity(value * 0.05),
                      ],
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.menu, color: theme["textColor"]),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 8.0,
                          right: 16.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePageView(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://randomuser.me/api/portraits/men/$_profileImageNumber.jpg',
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.person,
                                    color: theme["textColor"],
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    theme["buttonHighlight"]?.withOpacity(0.4) ??
                        const Color(0xFF9747FF).withOpacity(0.4),
                    theme["buttonHighlight"]?.withOpacity(0.2) ??
                        const Color(0xFF8E9AFF).withOpacity(0.2),
                    theme["buttonHighlight"]?.withOpacity(0.05) ??
                        const Color(0xFF8E9AFF).withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + kToolbarHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hi, ${homeViewModel.userName}👋",
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
                                          (_) =>
                                              InternationalTouristViewModel(),
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
                  const SizedBox(height: 16),
                  _buildDashboardStats(context, theme),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: theme["cardBackground"],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                color: theme["textColor"],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                color: theme["cardBackground"],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                style: TextStyle(
                                  color: theme["textColor"],
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Search...",
                                  hintStyle: TextStyle(
                                    color: theme["textColor"]?.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: theme["textColor"]?.withOpacity(0.5),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
        ],
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
                    homeViewModel.userName,
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authViewModel.userEmail ?? "",
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
                side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
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
                border: Border.all(
                  color: theme["textColor"]?.withOpacity(0.1) ?? Colors.grey,
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://randomuser.me/api/portraits/${transaction.isIncoming ? 'women' : 'men'}/${transaction.hashCode % 100}.jpg',
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

  Widget _buildDashboardStats(
    BuildContext context,
    Map<String, dynamic> theme,
  ) {
    final dashboardVm = Provider.of<DashboardViewModel>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme["cardBackground"],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaction Summary",
                style: TextStyle(
                  color: theme["textColor"],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme["textColor"],
                ),
                onPressed: () => _showDateRangePicker(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (dashboardVm.fromDate != null && dashboardVm.toDate != null)
            Text(
              "${DateFormat('MMM d, y').format(dashboardVm.fromDate!)} - ${DateFormat('MMM d, y').format(dashboardVm.toDate!)}",
              style: TextStyle(color: theme["secondaryText"], fontSize: 12),
            ),
          const SizedBox(height: 16),
          if (dashboardVm.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (dashboardVm.error != null)
            Text(dashboardVm.error!, style: TextStyle(color: Colors.red))
          else if (dashboardVm.dashboardCount != null)
            _buildStatsGrid(dashboardVm.dashboardCount!, theme)
          else
            Text(
              "Select a date range to view stats",
              style: TextStyle(color: theme["secondaryText"]),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DashboardCount count, Map<String, dynamic> theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _buildStatItem("Total", count.totalTransactions.toString(), theme),
        _buildStatItem(
          "Successful",
          count.successfulTransactions.toString(),
          theme,
          isSuccess: true,
        ),
        _buildStatItem(
          "Failed",
          count.failedTransactions.toString(),
          theme,
          isError: true,
        ),
        _buildStatItem(
          "Pending",
          count.pendingTransactions.toString(),
          theme,
          isPending: true,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Map<String, dynamic> theme, {
    bool isSuccess = false,
    bool isError = false,
    bool isPending = false,
  }) {
    Color color;
    if (isSuccess) {
      color = Colors.green;
    } else if (isError) {
      color = Colors.red;
    } else if (isPending) {
      color = Colors.orange;
    } else {
      color = theme["textColor"] ?? Colors.black;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: theme["secondaryText"], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final dashboardVm = Provider.of<DashboardViewModel>(context, listen: false);
    final initialFromDate =
        dashboardVm.fromDate ??
        DateTime.now().subtract(const Duration(days: 30));
    final initialToDate = dashboardVm.toDate ?? DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: initialFromDate,
        end: initialToDate,
      ),
    );

    if (picked != null) {
      dashboardVm.setFromDate(picked.start);
      dashboardVm.setToDate(picked.end);
      dashboardVm.fetchDashboardCount();
    }
  }
}
