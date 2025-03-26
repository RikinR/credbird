import 'package:credbird/view/splash_screen_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/international_tourist_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/onboarding_page_provider.dart';
import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
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
        ChangeNotifierProvider(create: (_) => InternationalTouristViewModel()),
        ChangeNotifierProvider(create: (_) => ForexRatesViewModel()),
        ChangeNotifierProvider(create: (_) => BeneficiaryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode:
          context.watch<ThemeProvider>().isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
