import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/viewmodel/onboarding_page_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
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

    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: IntroductionScreen(
            pages: onboardingScreens,
            globalBackgroundColor: theme["scaffoldBackground"],
            showBackButton: false,
            showNextButton: false,
            done: Text('Done', style: TextStyle(color: theme["textColor"])),
            onDone: () => completeOnboarding(context),
          ),
        ),
      ),
    );
  }
}
