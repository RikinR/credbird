// ignore_for_file: deprecated_member_use

import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          style: TextStyle(
            color: theme["textColor"],
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme["buttonHighlight"]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme["cardBackground"],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCurrencyDropdown(
                          context,
                          "From",
                          viewModel.baseCurrency,
                          (value) => viewModel.setBaseCurrency(value!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme["buttonHighlight"].withOpacity(0.2),
                        ),
                        child: Icon(
                          FontAwesomeIcons.arrowRightArrowLeft,
                          color: theme["buttonHighlight"],
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCurrencyDropdown(
                          context,
                          "To",
                          viewModel.targetCurrency,
                          (value) => viewModel.setTargetCurrency(value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme["scaffoldBackground"],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Exchange Rate",
                          style: TextStyle(
                            color: theme["secondaryText"],
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "1 ${viewModel.baseCurrency} = ${rate.toStringAsFixed(4)} ${viewModel.targetCurrency}",
                          style: TextStyle(
                            color: theme["buttonHighlight"],
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Rates",
                  style: TextStyle(
                    color: theme["textColor"],
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Base: ${viewModel.baseCurrency}",
                  style: TextStyle(
                    color: theme["secondaryText"],
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRateItem(
                    context,
                    "USD",
                    viewModel.getExchangeRateFor("USD"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "EUR",
                    viewModel.getExchangeRateFor("EUR"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "GBP",
                    viewModel.getExchangeRateFor("GBP"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "JPY",
                    viewModel.getExchangeRateFor("JPY"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "AUD",
                    viewModel.getExchangeRateFor("AUD"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "CAD",
                    viewModel.getExchangeRateFor("CAD"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "SGD",
                    viewModel.getExchangeRateFor("SGD"),
                    theme,
                  ),
                  _buildRateItem(
                    context,
                    "AED",
                    viewModel.getExchangeRateFor("AED"),
                    theme,
                  ),
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
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: value,
            isExpanded: true,
            items:
                viewModel.currencies
                    .map(
                      (currency) => DropdownMenuItem<String>(
                        value: currency,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme["buttonHighlight"].withOpacity(
                                  0.1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _getCurrencyFlag(currency),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                currency,
                                style: TextStyle(
                                  color: theme["textColor"],
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme["buttonHighlight"].withOpacity(0.3),
                ),
                color: theme["cardBackground"],
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: theme["buttonHighlight"],
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme["cardBackground"],
              ),
              offset: const Offset(0, -5),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme["cardBackground"],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme["buttonHighlight"].withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      _getCurrencyFlag(currency),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency,
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getCurrencyName(currency),
                      style: TextStyle(
                        color: theme["secondaryText"],
                        fontSize: 12,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              rate.toStringAsFixed(4),
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
    );
  }

  String _getCurrencyFlag(String currency) {
    final flags = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'AUD': '🇦🇺',
      'CAD': '🇨🇦',
      'INR': '🇮🇳',
      'SGD': '🇸🇬',
      'AED': '🇦🇪',
    };
    return flags[currency] ?? '💵';
  }

  String _getCurrencyName(String currency) {
    final names = {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'AUD': 'Australian Dollar',
      'CAD': 'Canadian Dollar',
      'INR': 'Indian Rupee',
      'SGD': 'Singapore Dollar',
      'AED': 'UAE Dirham',
    };
    return names[currency] ?? 'Currency';
  }
}
