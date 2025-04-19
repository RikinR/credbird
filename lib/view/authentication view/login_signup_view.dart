// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:credbird/view/authentication%20view/forgot_password/forgot_password_view.dart';
import 'package:credbird/view/authentication%20view/otp_verification_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/view/initial_views/landing_page_view.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginSignupView extends StatefulWidget {
  const LoginSignupView({super.key});

  @override
  State<LoginSignupView> createState() => _LoginSignupViewState();
}

class _LoginSignupViewState extends State<LoginSignupView>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool isLogin = true;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _signupWithoutOtp = false;
  String _dialCode = '+91';
  String _userType = 'STUDENT';

  @override
  void initState() {
    super.initState();
    _emailController.text = 'user@credbird.com';
    _passwordController.text = '12345';
    _phoneController.text = '9999999999';
    timeDilation = 2.0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black],
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.1,
            left: -50,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 2),
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: size.height * 0.2,
            right: -30,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_slideAnimation.value * 2),
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple.withOpacity(0.1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/appLogo.png',
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  isLogin ? "Welcome Back" : "Create Account",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isLogin
                                      ? "Login to manage your finances"
                                      : "Join us to start your financial journey",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            if (!isLogin) ...[
                              _buildTextField(
                                controller: _nameController,
                                hintText: "Full Name",
                                prefixIcon: Icons.person,
                                theme: theme,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900.withOpacity(
                                        0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: DropdownButton<String>(
                                      value: _dialCode,
                                      dropdownColor: Colors.grey.shade900,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      items:
                                          <String>['+91'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dialCode = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _phoneController,
                                      hintText: "Phone Number",
                                      prefixIcon: Icons.phone,
                                      theme: theme,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: DropdownButton<String>(
                                  value: _userType,
                                  dropdownColor: Colors.grey.shade900,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  items:
                                      <String>[
                                        'STUDENT',
                                        'INDIVIDUAL',
                                        'TRAVEL_AGENT',
                                        'EDUCATION_CONSULTANT',
                                        'MONEY_CHANGER',
                                        'REFERRAL_AGENT',
                                        'CORPORATE',
                                        'UNIVERSITY',
                                        'DMC',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _userType = newValue!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _signupWithoutOtp,
                                    onChanged: (value) {
                                      setState(() {
                                        _signupWithoutOtp = value!;
                                      });
                                    },
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.selected,
                                          )) {
                                            return Colors.blueAccent;
                                          }
                                          return Colors.grey;
                                        }),
                                  ),
                                  const Text(
                                    "Sign up without OTP",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                            _buildTextField(
                              controller: _emailController,
                              hintText: "Email",
                              prefixIcon: Icons.email,
                              theme: theme,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: "Password",
                              prefixIcon: Icons.lock,
                              theme: theme,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (isLogin) ...[
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    },
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.selected,
                                          )) {
                                            return Colors.blueAccent;
                                          }
                                          return Colors.grey;
                                        }),
                                  ),
                                  const Text(
                                    "Remember me",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            ElevatedButton(
                              onPressed: () async {
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                final name = _nameController.text.trim();
                                final phone = _phoneController.text.trim();

                                if (isLogin) {
                                  if (email.isEmpty || password.isEmpty) {
                                    _showErrorSnackbar(
                                      context,
                                      "Please fill all fields",
                                    );
                                    return;
                                  }
                                  try {
                                    await authViewModel.login(
                                      username: email,
                                      password: password,
                                      rememberMe: _rememberMe,
                                    );

                                    if (!authViewModel.isLoggedIn) {
                                      _showErrorSnackbar(
                                        context,
                                        "Invalid credentials",
                                      );
                                      return;
                                    }

                                    if (authViewModel.isLoggedIn) {
                                      _showSuccessSnackbar(
                                        context,
                                        "Login Successful!",
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const LandingPageView(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    String errorMessage =
                                        e.toString().contains(
                                              "Invalid Email Id or Password",
                                            )
                                            ? "Login failed. Please try again later."
                                            : "Invalid email or password.";
                                    _showErrorSnackbar(context, errorMessage);
                                  }
                                } else {
                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty ||
                                      phone.isEmpty) {
                                    _showErrorSnackbar(
                                      context,
                                      "Please fill all fields",
                                    );
                                    return;
                                  }

                                  if (_signupWithoutOtp) {
                                    await authViewModel.signupwithoutOtp(
                                      email: email,
                                      password: password,
                                      dialCode: _dialCode,
                                      phone: '+91$phone',
                                      userType: _userType,
                                    );
                                    authViewModel.updateProfile(
                                      name,
                                      email,
                                      _dialCode,
                                      phone,
                                      _userType,
                                    );
                                    _showSuccessSnackbar(
                                      context,
                                      "Account created! Logging you in.",
                                    );
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LandingPageView(),
                                      ),
                                    );
                                  } else {
                                    try {
                                      await authViewModel.signup(
                                        email: email,
                                        password: password,
                                        dialCode: _dialCode,
                                        phone: '+91$phone',
                                        userType: _userType,
                                      );
                                      authViewModel.updateProfile(
                                        name,
                                        email,
                                        _dialCode,
                                        phone,
                                        _userType,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => OtpVerificationView(
                                                email: email,
                                              ),
                                        ),
                                      );
                                    } catch (e) {
                                      String errorMessage =
                                          e.toString().contains(
                                                "Email Already Exists",
                                              )
                                              ? "Email already exists. Try another."
                                              : "Signup failed. Please try again.";
                                      _showErrorSnackbar(context, errorMessage);
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.blueAccent.withOpacity(0.3),
                              ),
                              child: Text(
                                isLogin ? "Login" : "Sign Up",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (isLogin) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const ForgotPasswordView(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                  _animationController.reset();
                                  _animationController.forward();
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      isLogin
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                  style: TextStyle(color: Colors.grey.shade400),
                                  children: [
                                    TextSpan(
                                      text: isLogin ? "Sign Up" : "Login",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required ThemeData theme,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade900.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
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
