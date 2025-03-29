import 'package:credbird/utils/card_view_utils.dart';
import 'package:credbird/viewmodel/card_provider.dart';
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
      appBar: _buildAppBar(context, theme, viewModel),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCardCarousel(context, viewModel, theme),
            const SizedBox(height: 24),
            buildQuickActionsRow(context, viewModel, theme),
            const SizedBox(height: 32),
            buildCardStatusTile(viewModel, theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    Map<String, dynamic> theme,
    CardViewModel viewModel,
  ) {
    return AppBar(
      title: const Text(
        "My Virtual Card",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: theme["textColor"],
      actions: [
        Text("Generate new card"),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.plus),
          onPressed: () => showCountrySelectionDialog(context),
          tooltip: 'Generate new virtual card',
        ),
      ],
    );
  }
}
