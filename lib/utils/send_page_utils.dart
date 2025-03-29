import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildPaymentMethodSelector(
  BuildContext context,
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
) {
  return Container(
    decoration: BoxDecoration(
      color: theme["cardBackground"],
      borderRadius: BorderRadius.circular(8),
    ),
    child: DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            onTap: (index) {
              viewModel.setPaymentMethod(PaymentMethod.values[index]);
            },
            labelColor: theme["buttonHighlight"],
            unselectedLabelColor: theme["secondaryText"],
            indicatorColor: theme["buttonHighlight"],
            tabs: const [
              Tab(text: "Contacts"),
              Tab(text: "CredBird ID"),
              Tab(text: "Beneficiary"),
            ],
          ),
        ],
      ),
    ),
  );
}

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

Widget buildCredBirdIdInput(
  Map<String, dynamic> theme,
  SendMoneyViewModel viewModel,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Text(
        "Recipient CredBird ID",
        style: TextStyle(
          color: theme["textColor"],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: viewModel.credBirdIdController,
        decoration: InputDecoration(
          hintText: "@username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(
            Icons.person_outline,
            color: theme["buttonHighlight"],
          ),
        ),
        style: TextStyle(color: theme["textColor"]),
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
                    color: theme["textColor"],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: theme["textColor"]),
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
    BeneficiaryProvider beneficiaryProvider,
    Map<String, dynamic> theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Select Beneficiary",
          style: TextStyle(
            color: theme["textColor"],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (beneficiaryProvider.beneficiaries.isEmpty)
          Text(
            "No beneficiaries added yet",
            style: TextStyle(color: theme["secondaryText"]),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: beneficiaryProvider.beneficiaries.length,
              itemBuilder: (context, index) {
                final beneficiary = beneficiaryProvider.beneficiaries[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      beneficiaryProvider.selectBeneficiary(beneficiary);
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme["cardBackground"],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              beneficiaryProvider.selectedBeneficiary?.id ==
                                      beneficiary.id
                                  ? theme["buttonHighlight"]!
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            beneficiary.name,
                            style: TextStyle(
                              color: theme["textColor"],
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            beneficiary.accountNumber,
                            style: TextStyle(
                              color: theme["secondaryText"],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            beneficiary.bankName,
                            style: TextStyle(
                              color: theme["secondaryText"],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
