import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget buildCardFront(CardViewModel viewModel, Map<String, dynamic> theme) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme["buttonHighlight"]!.withOpacity(0.8),
          const Color(0xFF03DAC6),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "CredBird",
              style: TextStyle(
                color: theme["scaffoldBackground"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "VISA",
              style: TextStyle(
                color: theme["scaffoldBackground"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.cardNumber
                  .replaceAllMapped(
                    RegExp(r'.{4}'),
                    (match) => '${match.group(0)} ',
                  )
                  .trim(),
              style: TextStyle(
                color: theme["scaffoldBackground"],
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CARD HOLDER",
                      style: TextStyle(
                        color: theme["scaffoldBackground"]!.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      viewModel.cardHolder,
                      style: TextStyle(
                        color: theme["scaffoldBackground"],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EXPIRES",
                      style: TextStyle(
                        color: theme["scaffoldBackground"]!.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      viewModel.expiryDate,
                      style: TextStyle(
                        color: theme["scaffoldBackground"],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildCardBack(CardViewModel viewModel, Map<String, dynamic> theme) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme["buttonHighlight"]!.withOpacity(0.8),
          const Color(0xFF03DAC6),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          color: Colors.black,
          margin: const EdgeInsets.only(bottom: 20),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Card Number",
              style: TextStyle(
                color: theme["scaffoldBackground"]!.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            Text(
              viewModel.cardNumber
                  .replaceAllMapped(
                    RegExp(r'.{4}'),
                    (match) => '${match.group(0)} ',
                  )
                  .trim(),
              style: TextStyle(
                color: theme["scaffoldBackground"],
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EXPIRY DATE",
                      style: TextStyle(
                        color: theme["scaffoldBackground"]!.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      viewModel.expiryDate,
                      style: TextStyle(
                        color: theme["scaffoldBackground"],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CVV",
                      style: TextStyle(
                        color: theme["scaffoldBackground"]!.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      viewModel.cvv,
                      style: TextStyle(
                        color: theme["scaffoldBackground"],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "VISA",
            style: TextStyle(
              color: theme["scaffoldBackground"],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildCardAction(
  IconData icon,
  String text,
  Map<String, dynamic> theme, {
  required VoidCallback onPressed,
}) {
  return Column(
    children: [
      IconButton(
        icon: FaIcon(icon),
        color: theme["buttonHighlight"],
        iconSize: 24,
        onPressed: onPressed,
      ),
      const SizedBox(height: 8),
      Text(text, style: TextStyle(color: theme["textColor"])),
    ],
  );
}

void showWalletOptions(BuildContext context, CardViewModel viewModel) {
  showModalBottomSheet(
    context: context,
    backgroundColor:
        Provider.of<ThemeProvider>(
          context,
          listen: false,
        ).themeConfig["cardBackground"],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.apple),
                title: const Text("Add to Apple Pay"),
                onTap: () {
                  viewModel.addToApplePay(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.google),
                title: const Text("Add to Google Pay"),
                onTap: () {
                  viewModel.addToGooglePay(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
  );
}

Widget buildCardCarousel(
  BuildContext context,
  CardViewModel viewModel,
  Map<String, dynamic> theme,
) {
  return SizedBox(
    height: 220,
    child: PageView(
      onPageChanged: (index) => viewModel.toggleCardSide(),
      children: [
        buildCardFront(viewModel, theme),
        buildCardBack(viewModel, theme),
      ],
    ),
  );
}

Widget buildQuickActionsRow(
  BuildContext context,
  CardViewModel viewModel,
  Map<String, dynamic> theme,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildActionButton(
        icon:
            viewModel.isCardActive
                ? FontAwesomeIcons.lock
                : FontAwesomeIcons.lockOpen,
        label: viewModel.isCardActive ? "Freeze" : "Unfreeze",
        theme: theme,
        onPressed: viewModel.toggleCardActivation,
      ),
      _buildActionButton(
        icon: FontAwesomeIcons.qrcode,
        label: "Pay",
        theme: theme,
        onPressed: () => _showPaymentOptions(context),
      ),
      _buildActionButton(
        icon: FontAwesomeIcons.wallet,
        label: "Wallet",
        theme: theme,
        onPressed: () => showWalletOptions(context, viewModel),
      ),
    ],
  );
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required Map<String, dynamic> theme,
  required VoidCallback onPressed,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: FaIcon(icon),
        color: theme["buttonHighlight"],
        onPressed: onPressed,
        iconSize: 24,
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: theme["textColor"], fontSize: 12)),
    ],
  );
}

Widget buildCardStatusTile(
  CardViewModel viewModel,
  Map<String, dynamic> theme,
) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: theme["cardBorder"] ?? Colors.grey.shade300),
    ),
    leading: Icon(
      viewModel.isCardActive ? Icons.check_circle : Icons.remove_circle,
      color:
          viewModel.isCardActive
              ? theme["positiveAmount"]
              : theme["negativeAmount"],
    ),
    title: Text(
      viewModel.isCardActive ? "Card is active" : "Card is frozen",
      style: TextStyle(color: theme["textColor"], fontWeight: FontWeight.w500),
    ),
    trailing: TextButton(
      onPressed: viewModel.toggleCardActivation,
      child: Text(
        viewModel.isCardActive ? "FREEZE CARD" : "ACTIVATE CARD",
        style: TextStyle(
          color: theme["buttonHighlight"],
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

void showCountrySelectionDialog(BuildContext context) {
  final viewModel = Provider.of<CardViewModel>(context, listen: false);
  final countries = ['USA', 'UK', 'Canada', 'Australia', 'Germany', 'France'];

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Select Country for Card Options'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(countries[index]),
                  onTap: () {
                    viewModel.selectCountry(countries[index]);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Card Options for ${countries[index]} generated',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
  );
}

void _showPaymentOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('Show QR Code'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Card Details'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
  );
}
