import 'package:credbird/viewmodel/home_page_viewmodels/international_tourist_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InternationalTouristView extends StatelessWidget {
  const InternationalTouristView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<InternationalTouristViewModel>(context);

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: Text(
          "International Payment",
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
            _buildContactSelector(theme, viewModel, context),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildCurrencyDropdown(
                    context,
                    "From",
                    viewModel.selectedFromCurrency,
                    (value) => viewModel.setFromCurrency(value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCurrencyDropdown(
                    context,
                    "To",
                    viewModel.selectedToCurrency,
                    (value) => viewModel.setToCurrency(value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "1 ${viewModel.selectedFromCurrency} = ${viewModel.exchangeRate.toStringAsFixed(4)} ${viewModel.selectedToCurrency}",
              style: TextStyle(
                color: theme["secondaryText"],
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme["cardBackground"],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount to send",
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${viewModel.selectedFromCurrency} ${viewModel.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: theme["textColor"],
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "≈ ${viewModel.selectedToCurrency} ${viewModel.convertedAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: theme["secondaryText"],
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  for (int i = 1; i <= 9; i++)
                    _buildNumberButton(i.toString(), theme, () {
                      viewModel.setAmount(viewModel.amount * 10 + i);
                    }),
                  _buildNumberButton(".", theme, () {}),
                  _buildNumberButton("0", theme, () {
                    viewModel.setAmount(viewModel.amount * 10);
                  }),
                  _buildNumberButton("⌫", theme, () {
                    viewModel.setAmount((viewModel.amount ~/ 10).toDouble());
                  }),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["buttonHighlight"],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => viewModel.sendInternationalPayment(context),
                child: Text(
                  "Send Payment",
                  style: TextStyle(
                    color: theme["textColor"],
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSelector(
    Map<String, dynamic> theme,
    InternationalTouristViewModel viewModel,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Send to",
          style: TextStyle(
            color: theme["secondaryText"],
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...viewModel.recentContacts.map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => viewModel.selectContact(contact),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                viewModel.selectedContact == contact
                                    ? theme["buttonHighlight"]?.withOpacity(0.2)
                                    : theme["cardBackground"],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  viewModel.selectedContact == contact
                                      ? theme["buttonHighlight"]!
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(contact),
                              style: TextStyle(
                                color: theme["textColor"],
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.split(' ')[0],
                        style: TextStyle(
                          color: theme["textColor"],
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => viewModel.addNewContact(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme["cardBackground"],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme["buttonHighlight"]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: theme["buttonHighlight"],
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Add",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }

  Widget _buildCurrencyDropdown(
    BuildContext context,
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    final viewModel = Provider.of<InternationalTouristViewModel>(context);

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

  Widget _buildNumberButton(
    String text,
    Map<String, dynamic> theme,
    VoidCallback onPressed,
  ) {
    return Material(
      color: theme["cardBackground"],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: theme["textColor"],
              fontFamily: 'Roboto',
              fontWeight: text == "⌫" ? FontWeight.w300 : FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
