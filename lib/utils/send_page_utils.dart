// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget buildContactSelector(
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Text(
        "Recent Contacts",
        style: TextStyle(
          color: theme["textColor"],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...viewModel.recentContacts.map(
              (contact) => buildContactItem(
                contact,
                theme,
                viewModel.selectedContact == contact,
                () => viewModel.selectContact(contact),
              ),
            ),
            buildAddContactItem(theme, () => viewModel.addNewContact(context)),
          ],
        ),
      ),
    ],
  );
}

Widget buildAmountInput(
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Text(
        "Amount",
        style: TextStyle(
          color: theme["textColor"],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: viewModel.amountController,
        style: TextStyle(
          color: theme["textColor"],
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "\$0",
          hintStyle: TextStyle(color: theme["secondaryText"]),
          prefixText: "\$ ",
          prefixStyle: TextStyle(color: theme["textColor"], fontSize: 32),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        readOnly: true,
      ),
    ],
  );
}

Widget buildNumberPad(
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
) {
  return Column(
    children: [
      const SizedBox(height: 24),
      GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: List.generate(9, (index) {
          return buildNumberButton(
            (index + 1).toString(),
            theme,
            () => viewModel.addToAmount((index + 1).toString()),
          );
        })..addAll([
          buildNumberButton(".", theme, () => viewModel.addToAmount(".")),
          buildNumberButton("0", theme, () => viewModel.addToAmount("0")),
          buildActionButton(
            FontAwesomeIcons.deleteLeft,
            theme,
            () => viewModel.addToAmount("backspace"),
          ),
        ]),
      ),
    ],
  );
}

Widget buildConfirmButton(
  BuildContext context,
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme["buttonHighlight"],
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await viewModel.sendMoney(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Confirm Payment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme["backgroundColor"],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: theme["backgroundColor"]),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildContactItem(
  String contact,
  Map<String, dynamic> theme,
  bool isSelected,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                isSelected ? theme["buttonHighlight"] : theme["cardBackground"],
            child: Text(
              contact[0],
              style: TextStyle(
                color:
                    isSelected
                        ? theme["scaffoldBackground"]
                        : theme["textColor"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contact.split(" ")[0],
            style: TextStyle(
              color: theme["textColor"],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildAddContactItem(Map<String, dynamic> theme, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme["cardBackground"],
            child: FaIcon(FontAwesomeIcons.plus, color: theme["textColor"]),
          ),
          const SizedBox(height: 8),
          Text("Add", style: TextStyle(color: theme["textColor"])),
        ],
      ),
    ),
  );
}

Widget buildNumberButton(
  String number,
  Map<String, dynamic> theme,
  VoidCallback onPressed,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: theme["cardBackground"],
      foregroundColor: theme["textColor"],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child: Text(number, style: const TextStyle(fontSize: 24)),
  );
}

Widget buildActionButton(
  IconData icon,
  Map<String, dynamic> theme,
  VoidCallback onPressed,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: theme["cardBackground"],
      foregroundColor: theme["textColor"],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child: FaIcon(icon, size: 24),
  );
}

Widget buildBeneficiarySelector(
  BuildContext context,
  BeneficiaryProvider provider,
  Map<String, dynamic> theme,
) {
  final selectedId = provider.selectedBeneficiary?.id;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 16, bottom: 8),
        child: Text("Select Beneficiary"),
      ),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.beneficiaries.length,
          itemBuilder: (context, index) {
            final b = provider.beneficiaries[index];
            final isSelected = b.id == selectedId;

            return GestureDetector(
              onTap: () {
                provider.selectBeneficiary(b);
              },
              onLongPress: () {
                _showBeneficiaryDetail(context, b.id);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? theme['primary'] : theme['cardColor'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 20,
                      child: Text(
                        _getInitials(b.name),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      b.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSelected ? 14 : 12,
                        color:
                            isSelected
                                ? const Color.fromARGB(255, 102, 7, 255)
                                : theme['textColor'],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

void _showBeneficiaryDetail(BuildContext context, String beneficiaryId) async {
  final provider = Provider.of<BeneficiaryProvider>(context, listen: false);
  final theme = Provider.of<ThemeProvider>(context, listen: false).themeConfig;
  final beneficiary = await provider.fetchBeneficiaryDetailById(beneficiaryId);

  if (beneficiary == null) return;

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(
            beneficiary.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank: ${beneficiary.bankName}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Account: ${beneficiary.accountNumber}",
                style: TextStyle(fontSize: 18),
              ),
              Text("City: ${beneficiary.city}", style: TextStyle(fontSize: 18)),
              Text(
                "Country: ${beneficiary.country}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "SWIFT: ${beneficiary.swiftCode}",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(
                  beneficiary.isActivated! ? Icons.block : Icons.check_circle,
                  color: beneficiary.isActivated! ? Colors.red : Colors.green,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme["primary"],
                ),
                onPressed: () async {
                  final updated = await provider.toggleBeneficiaryActivation(
                    beneficiaryId,
                    !beneficiary.isActivated!,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        updated
                            ? "Beneficiary status updated"
                            : "Update failed",
                      ),
                    ),
                  );
                  await provider.fetchBeneficiaries();
                },
                label: Text(
                  beneficiary.isActivated! ? "Deactivate" : "Activate",
                  style: TextStyle(
                    color: beneficiary.isActivated! ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
  );
}

String _getInitials(String name) {
  final parts = name.trim().split(" ");
  if (parts.length >= 2) {
    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
    return parts[0][0].toUpperCase();
  }
  return "?";
}
