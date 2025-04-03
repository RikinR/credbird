import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/landing_page_view.dart';
import 'package:credbird/view/onboarding_screen_view.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/viewmodel/usage_provider.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme["buttonHighlight"]!.withOpacity(0.8),
              theme["scaffoldBackground"],
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                    duration: const Duration(seconds: 10),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          theme["buttonHighlight"]!.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        radius: 0.8,
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .scale(duration: 5000.ms)
                  .fade(begin: 0.5, end: 0),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: theme["cardGradient"],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme["buttonHighlight"]!.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: theme["buttonHighlight"]!.withOpacity(
                                  0.5,
                                ),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/appLogo.png',
                            width: 90,
                            height: 90,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          "CredBird",
                          style: TextStyle(
                            color: theme["textColor"],
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.8,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: theme["buttonHighlight"]!,
                              ),
                            ],
                          ),
                        ).animate().shimmer(
                          delay: 500.ms,
                          duration: 1000.ms,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          "Your Only Ebank",
                          style: TextStyle(
                            color: theme["secondaryText"],
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ).animate().fadeIn(duration: 500.ms),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100,
              left: 50,
              child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme["glassEffect"],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .move(duration: 4000.ms, curve: Curves.easeInOut)
                  .fade(duration: 4000.ms),
            ),
            Positioned(
              bottom: 150,
              right: 30,
              child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme["glassEffect"],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .move(duration: 5000.ms, curve: Curves.easeInOut)
                  .fade(duration: 5000.ms),
            ),
          ],
        ),
      ),
    );
  }
}
