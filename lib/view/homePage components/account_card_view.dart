import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatelessWidget {
  final String title;
  final String amount;
  final String cardNumber;

  const AccountCard({
    super.key,
    required this.title,
    required this.amount,
    required this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme['highlightColor'],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: theme['textColor'], fontSize: 16),
                ),
                Text(
                  "•••• $cardNumber",
                  style: TextStyle(color: theme['switchActiveColor']),
                ),
              ],
            ),
            Text(
              amount,
              style: TextStyle(color: theme['textColor'], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
