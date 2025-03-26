import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/viewmodel/onboarding_page_provider.dart';
import 'package:credbird/viewmodel/usage_provider.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreenView extends StatelessWidget {
  const OnboardingScreenView({super.key});

  void completeOnboarding(BuildContext context) {
    context.read<UsageProvider>().changeUseTime();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignupView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingScreens = context.watch<OnboardPageProvider>().list;

    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        pages: onboardingScreens,
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
          ),
        ),
        next: Icon(Icons.arrow_forward, color: Colors.black87),
        back: Icon(Icons.arrow_back, color: Colors.black87),
        done: Text(
          'Get Started',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Roboto',
          ),
        ),
        onDone: () => completeOnboarding(context),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.black87,
          color: Colors.black54,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: Colors.white,
        skipOrBackFlex: 0,
        nextFlex: 0,
        animationDuration: 300,
        baseBtnStyle: TextButton.styleFrom(backgroundColor: Colors.white),
      ),
    );
  }
}
