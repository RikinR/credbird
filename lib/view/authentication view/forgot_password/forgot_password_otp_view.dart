// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:credbird/view/authentication%20view/forgot_password/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';

class ForgotPasswordOtpView extends StatefulWidget {
  final String email;
  const ForgotPasswordOtpView({super.key, required this.email});

  @override
  State<ForgotPasswordOtpView> createState() => _ForgotPasswordOtpViewState();
}

class _ForgotPasswordOtpViewState extends State<ForgotPasswordOtpView> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We sent a code to ${widget.email}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey.shade900.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(
                              context,
                            ).requestFocus(_focusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(
                              context,
                            ).requestFocus(_focusNodes[index - 1]);
                          }
                        },
                        onTap: () {
                          _otpControllers[index]
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: _otpControllers[index].text.length,
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleOtpVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleOtpVerification() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      _showErrorSnackbar(context, 'Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final response = await authViewModel.verifyOtp(
        username: widget.email,
        otp: otp,
      );
      final token = response['token'];

      _showSuccessSnackbar(context, 'OTP verified successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResetPasswordView(
                email: widget.email,
                token: token,
              ),
        ),
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Failed to verify OTP: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
