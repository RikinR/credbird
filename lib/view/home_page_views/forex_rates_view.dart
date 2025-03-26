import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForexRatesView extends StatelessWidget {
  const ForexRatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<ForexRatesViewModel>(context);
    final rate = viewModel.getExchangeRate();

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "Forex Rates",
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
                Expanded(
                  child: _buildCurrencyDropdown(
                    context,
                    "Base Currency",
                    viewModel.baseCurrency,
                    (value) => viewModel.setBaseCurrency(value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCurrencyDropdown(
                    context,
                    "Target Currency",
                    viewModel.targetCurrency,
                    (value) => viewModel.setTargetCurrency(value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme["cardBackground"],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Exchange Rate",
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "1 ${viewModel.baseCurrency} = ${rate.toStringAsFixed(4)} ${viewModel.targetCurrency}",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildRateItem(context, "USD", 0.012, theme),
                  _buildRateItem(context, "EUR", 0.011, theme),
                  _buildRateItem(context, "GBP", 0.0096, theme),
                  _buildRateItem(context, "JPY", 1.78, theme),
                  _buildRateItem(context, "AUD", 0.018, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(
    BuildContext context,
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<ForexRatesViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme["secondaryText"],
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme["cardBackground"],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: theme["cardBackground"],
            style: TextStyle(
              color: theme["textColor"],
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
            items:
                viewModel.currencies
                    .map(
                      (currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildRateItem(
    BuildContext context,
    String currency,
    double rate,
    Map<String, dynamic> theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme["cardBackground"],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currency,
            style: TextStyle(
              color: theme["textColor"],
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            rate.toStringAsFixed(4),
            style: TextStyle(
              color: theme["textColor"],
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
