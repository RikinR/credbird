import 'package:credbird/model/remittance/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  double _balance = 3576.89;
  String _userName = "User";
  String? _userEmail;
  String? _userPhone;
  String? _userAddress;
  String? _profileImagePath;
  bool _isBalanceVisible = true;
  bool _isAccountLoading = false;

  final List<Transaction> _transactions = [
    Transaction(
      recipient: "Shahid Miah",
      date: "2023/09/22",
      amount: 340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Jonas Hopfmann",
      date: "2024/09/22",
      amount: 140.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Martha Nielman",
      date: "2025/01/24",
      amount: 1340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Raman Thomas",
      date: "2025/02/21",
      amount: 1340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Cameron Williamson",
      date: "2023/09/22",
      amount: 240.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Shahid Miah",
      date: "2023/09/22",
      amount: 340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Jonas Hopfmann",
      date: "2024/09/22",
      amount: 140.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Martha Nielman",
      date: "2025/01/24",
      amount: 1340.00,
      isIncoming: true,
    ),
    Transaction(
      recipient: "Raman Thomas",
      date: "2025/02/21",
      amount: 1340.00,
      isIncoming: false,
    ),
    Transaction(
      recipient: "Cameron Williamson",
      date: "2023/09/22",
      amount: 240.00,
      isIncoming: false,
    ),
  ];

  double get balance => _balance;
  String get userName => _userName;
  bool get isBalanceVisible => _isBalanceVisible;
  List<Transaction> get transactions => _transactions;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get userAddress => _userAddress;
  String? get profileImagePath => _profileImagePath;
  bool get isAccountLoading => _isAccountLoading;

  HomeViewModel() {
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    _isAccountLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? "User";
    _userEmail = prefs.getString('user_email') ?? "user@credbird.com";
    _userPhone = prefs.getString('user_phone') ?? "";
    _userAddress = prefs.getString('user_address') ?? "";
    _profileImagePath = prefs.getString('profile_image_path');

    _isAccountLoading = false;
    notifyListeners();
  }

  Future<void> updateAccountDetails({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    _isAccountLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (name != null && name.isNotEmpty) {
      await prefs.setString('user_name', name);
      _userName = name;
    }
    if (email != null && email.isNotEmpty) {
      await prefs.setString('user_email', email);
      _userEmail = email;
    }
    if (phone != null && phone.isNotEmpty) {
      await prefs.setString('user_phone', phone);
      _userPhone = phone;
    }
    if (address != null && address.isNotEmpty) {
      await prefs.setString('user_address', address);
      _userAddress = address;
    }

    _isAccountLoading = false;
    
    notifyListeners();
  }

  Future<void> updateProfileImage(String imagePath) async {
    _isAccountLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', imagePath);
    _profileImagePath = imagePath;

    _isAccountLoading = false;
    notifyListeners();
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await updateProfileImage(pickedFile.path);
    }
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void addFunds(double amount) {
    _balance += amount;
    notifyListeners();
  }

  void requestVirtualCard(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card Options request initiated')),
    );
  }

  void internationalTourist(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('International tourist service started')),
    );
  }

  void showForexRates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Displaying live forex rates')),
    );
  }

  void contactSupport(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connecting to support...')));
  }

  void showTransactionHistory(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Transaction History'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction.isIncoming
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaction.isIncoming ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction.recipient),
                    subtitle: Text(transaction.date),
                    trailing: Text(
                      '${transaction.isIncoming ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            transaction.isIncoming ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
