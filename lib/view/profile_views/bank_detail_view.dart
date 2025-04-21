// ignore_for_file: use_build_context_synchronously

import 'package:credbird/viewmodel/profile_providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetailsView extends StatefulWidget {
  const BankDetailsView({super.key});

  @override
  State<BankDetailsView> createState() => _BankDetailsViewState();
}

class _BankDetailsViewState extends State<BankDetailsView> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  String? _verifiedId;
  bool _isRefundAccount = false;
  bool _loading = false;

  Future<void> _verifyIfsc() async {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final account = _accountController.text.trim();
    final ifsc = _ifscController.text.trim();

    if (account.isEmpty || ifsc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter account and IFSC')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final data = await provider.verifyBankDetailsAndReturn(account, ifsc);
      _accountNameController.text = data['full_name'];
      _verifiedId = data['verifiedId'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final account = _accountController.text.trim();
    final ifsc = _ifscController.text.trim();
    final name = _accountNameController.text.trim();
    final verifiedId = _verifiedId;

    if (account.isEmpty || ifsc.isEmpty || name.isEmpty || verifiedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete bank verification')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final success = await provider.submitBankDetail(
        accountNumber: account,
        ifsc: ifsc,
        accountName: name,
        verifiedId: verifiedId,
        refundAccount: _isRefundAccount,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bank detail submitted successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Bank Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(labelText: 'Account Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ifscController,
              decoration: InputDecoration(
                labelText: 'IFSC Code',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _verifyIfsc,
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _accountNameController,
              decoration: const InputDecoration(labelText: 'Account Name'),
              enabled: false,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Use for Refunds'),
              value: _isRefundAccount,
              onChanged: (val) => setState(() => _isRefundAccount = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _loading
                      ? const CircularProgressIndicator()
                      : const Text('Submit Bank Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
