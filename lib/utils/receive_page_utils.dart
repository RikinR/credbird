import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

Widget buildAddContactButton(BuildContext context, Map<String, dynamic> theme) {
  return GestureDetector(
    onTap:
        () => showAddContactDialog(
          context,
          Provider.of<ReceiveMoneyViewModel>(context),
        ),
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme["cardBackground"],
            child: Icon(Icons.add, color: theme["buttonHighlight"], size: 20),
          ),
          const SizedBox(height: 8),
          Text("Add", style: TextStyle(color: theme["textColor"])),
        ],
      ),
    ),
  );
}

void showAddContactDialog(
  BuildContext context,
  ReceiveMoneyViewModel viewModel,
) {
  final theme = Provider.of<ThemeProvider>(context).themeConfig;
  final TextEditingController contactController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: theme["cardBackground"],
          title: Text(
            "Add New Contact",
            style: TextStyle(color: theme["textColor"]),
          ),
          content: TextField(
            controller: contactController,
            decoration: InputDecoration(
              hintText: "Enter contact name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(color: theme["textColor"]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: theme["buttonHighlight"]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme["buttonHighlight"],
              ),
              onPressed: () {
                if (contactController.text.isNotEmpty) {
                  viewModel.addContact(contactController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Add",
                style: TextStyle(color: theme["scaffoldBackground"]),
              ),
            ),
          ],
        ),
  );
}

void showQRCodeDialog(BuildContext context, String userId) {
  final theme = Provider.of<ThemeProvider>(context).themeConfig;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: theme["cardBackground"],
          title: Text(
            "Scan to Pay",
            style: TextStyle(color: theme["textColor"]),
            textAlign: TextAlign.center,
          ),
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.qr_code, size: 150),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(color: theme["buttonHighlight"]),
                ),
              ),
            ),
          ],
        ),
  );
}
