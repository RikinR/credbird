import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final selected = provider.selectedBeneficiary;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      const Text(
        "Select Beneficiary",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 100,
        child:
            provider.beneficiaries.isEmpty
                ? const Center(child: Text("No beneficiaries added"))
                : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.beneficiaries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final beneficiary = provider.beneficiaries[index];
                    final isSelected = beneficiary.id == selected?.id;

                    return GestureDetector(
                      onTap: () => provider.selectBeneficiary(beneficiary),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                isSelected
                                    ? theme["positiveAmount"]
                                    : theme["unhighlightedButton"],
                            child: Text(
                              _getInitials(beneficiary.name),
                              style: TextStyle(
                                color: theme["backgroundColor"],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 70,
                            child: Text(
                              beneficiary.name.split(' ').first,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isSelected
                                        ? theme["textColor"]
                                        : theme["secondaryText"],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    ],
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
