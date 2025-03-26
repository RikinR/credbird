import 'package:credbird/utils/card_view_utils.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<CardViewModel>(context);

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "My Card",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme["textColor"],
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus),
            onPressed:
                () => Provider.of<HomeViewModel>(
                  context,
                  listen: false,
                ).requestVirtualCard(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView(
                onPageChanged: (index) {
                  viewModel.toggleCardSide();
                },
                children: [
                  buildCardFront(viewModel, theme),
                  buildCardBack(viewModel, theme),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCardAction(
                  viewModel.isCardActive
                      ? FontAwesomeIcons.lock
                      : FontAwesomeIcons.lockOpen,
                  "Freeze",
                  theme,
                  onPressed: viewModel.toggleCardActivation,
                ),
                buildCardAction(
                  FontAwesomeIcons.qrcode,
                  "Pay",
                  theme,
                  onPressed: () {},
                ),
                buildCardAction(
                  FontAwesomeIcons.wallet,
                  "Add to Wallet",
                  theme,
                  onPressed: () => showWalletOptions(context, viewModel),
                ),
                buildCardAction(
                  FontAwesomeIcons.ellipsis,
                  "More",
                  theme,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: viewModel.toggleCardActivation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme["cardBackground"],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      viewModel.isCardActive
                          ? Icons.check_circle
                          : Icons.remove_circle,
                      color:
                          viewModel.isCardActive
                              ? theme["positiveAmount"]
                              : theme["negativeAmount"],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      viewModel.isCardActive
                          ? "Card is active"
                          : "Card is frozen",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      viewModel.isCardActive ? "Freeze" : "Activate",
                      style: TextStyle(
                        color: theme["buttonHighlight"],
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
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
}
