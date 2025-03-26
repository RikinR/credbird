import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/landing_page_view.dart';
import 'package:credbird/view/onboarding_screen_view.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/viewmodel/usage_provider.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.wait([
      _controller.animateTo(1.0),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    if (!mounted) return;

    final usageProvider = Provider.of<UsageProvider>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                usageProvider.isFirstTime
                    ? const OnboardingScreenView()
                    : (authViewModel.isLoggedIn
                        ? const LandingPageView()
                        : const LoginSignupView()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900.withOpacity(0.8), Colors.black],
                stops: const [0.1, 0.9],
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/appLogo.png',
                        width: 120,
                        height: 120,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "CredBird",
                        style: TextStyle(
                          color: theme["textColor"],
                          fontSize: 28,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
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
    );
  }
}
