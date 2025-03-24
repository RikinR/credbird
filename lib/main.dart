import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/view/landing_page_view.dart';
import 'package:credbird/view/onboarding_screen_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_provider.dart';
import 'package:credbird/viewmodel/onboarding_page_provider.dart';
import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/viewmodel/usage_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsageProvider(pref: prefs)),
        ChangeNotifierProvider(create: (_) => OnboardPageProvider()),
        ChangeNotifierProvider(create: (_) => PagesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CardViewModel()),
        ChangeNotifierProvider(create: (_) => SendMoneyViewModel()),
        ChangeNotifierProvider(create: (_) => ReceiveMoneyViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final usageProvider = Provider.of<UsageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: usageProvider.isFirstTime
          ? const OnboardingScreenView()
          : (authViewModel.isLoggedIn ? const LandingPageView() : const LoginSignupView()),
    );
  }
}
