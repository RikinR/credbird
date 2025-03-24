import 'package:credbird/viewmodel/send_money_provider.dart';
import 'package:flutter/material.dart';

void showConfirmationDialog(
    BuildContext context,
    SendMoneyViewModel viewModel,
    String recipient,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Transfer"),
          content: Text(
            "Are you sure you want to send \$${viewModel.amount.toStringAsFixed(2)} to $recipient?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                viewModel.sendMoney(context, recipient);
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void showAddRecipientDialog(
    BuildContext context,
    SendMoneyViewModel viewModel,
  ) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Recipient"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter recipient name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                viewModel.addRecipient(nameController.text);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

