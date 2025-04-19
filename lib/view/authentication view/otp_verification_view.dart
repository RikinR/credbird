// ignore_for_file: use_build_context_synchronously, unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/view/initial_views/landing_page_view.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;
  const OtpVerificationView({super.key, required this.email});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
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

  void _handleOtpVerification() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.verifyOtp(username: widget.email, otp: otp);

      _showSuccessSnackbar(context, 'OTP verification Successful');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPageView()),
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Could not verify the OTP');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleOtpPaste(String value) {
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = value[i];
        if (i < 5) {
          _focusNodes[i].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      }
    }
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
