import 'package:credbird/repositories/auth_repository/auth_repository.dart';
import 'package:credbird/repositories/remitence_repository/invoices_repository.dart';
import 'package:credbird/repositories/user_repository/dashboard_repository.dart';
import 'package:credbird/repositories/user_repository/transaction_repository.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/dashboard_viewmodel.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/transaction_view_model.dart';
import 'package:credbird/viewmodel/profile_providers/kyc_provider.dart';
import 'package:credbird/viewmodel/profile_providers/registration_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/intermediary_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/invoices_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/remitter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:credbird/view/initial_views/splash_screen_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/card_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/forex_rates_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/home_provider.dart';
import 'package:credbird/viewmodel/home_page_viewmodels/international_tourist_provider.dart';
import 'package:credbird/viewmodel/onboarding_page_provider.dart';
import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/receive_money_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/beneficiary_provider.dart';
import 'package:credbird/viewmodel/send_page_viewmodels/send_money_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/viewmodel/usage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthRepository())),
        ChangeNotifierProvider(create: (_) => InternationalTouristViewModel()),
        ChangeNotifierProvider(create: (_) => ForexRatesViewModel()),
        ChangeNotifierProvider(create: (_) => BeneficiaryProvider()),
        ChangeNotifierProvider(create: (_) => KYCProvider()),
        ChangeNotifierProvider(create: (_) => RemitterProvider()),
        ChangeNotifierProvider(create: (_) => IntermediaryProvider()),
        ChangeNotifierProvider(
          create: (_) => TransactionViewModel(TransactionRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(DashboardRepository()),
        ),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(
          create: (_) => InvoiceViewModel(InvoiceRepository()),
        ),
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
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        primaryTextTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().primaryTextTheme,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(elevation: 0),
        ),
        appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
        cardTheme: const CardTheme(elevation: 0),
      ),
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        primaryTextTheme: GoogleFonts.interTextTheme(
          ThemeData.light().primaryTextTheme,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(elevation: 0),
        ),
        appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
        cardTheme: const CardTheme(elevation: 0),
      ),
      themeMode:
          context.watch<ThemeProvider>().isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
