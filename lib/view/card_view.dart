import 'package:credbird/utils/card_view_utils.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      body: Center(
        child: Consumer<CardViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => cardKey.currentState?.toggleCard(),
                      child: SizedBox(
                        height: 200,
                        width: 350,
                        child: FlipCard(
                          key: cardKey,
                          direction: FlipDirection.HORIZONTAL,
                          front: buildCardFront(),
                          back: buildCardBack(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIconButton(Icons.ac_unit, "Freeze"),
                    buildIconButton(Icons.remove_red_eye, "View"),
                    buildIconButton(Icons.settings, "Settings"),
                    buildIconButton(Icons.more_horiz, "More"),
                  ],
                ),

                const SizedBox(height: 20),

                buildWalletButton(
                  icon: Icons.apple,
                  text: "Add to Apple Wallet",
                  onPressed: () {},
                ),

                const SizedBox(height: 10),

                buildWalletButton(
                  icon: Icons.credit_card,
                  text: "Add to Google Wallet",
                  onPressed: () {},
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Tap to activate or deactivate the card",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: viewModel.toggleCardActivation,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color:
                            viewModel.isCardActive
                                ? Colors.green[800]
                                : Colors.red[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            viewModel.isCardActive
                                ? "Your virtual card is active"
                                : "Your card is deactivated",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
