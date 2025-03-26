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
