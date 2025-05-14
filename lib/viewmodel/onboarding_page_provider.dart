import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardPageProvider extends ChangeNotifier {
  final List<PageViewModel> _list = [
    PageViewModel(
      title: "Welcome to Credbird!",
      body: "Your trusted financial companion for seamless transactions",
      image: Center(
        child: Container(
          color: const Color.fromARGB(255, 10, 31, 60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/appLogo.png', height: 250),
          ),
        ),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 40),
        imagePadding: EdgeInsets.only(top: 80),
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Payments Made Easy",
      body: "Send and receive money with just a few taps",
      image: Center(child: Image.asset('assets/payments.jpg', height: 250)),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 40),
        imagePadding: EdgeInsets.only(top: 80),
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Card Options",
      body: "Generate Card Options for secure online payments",
      image: Center(
        child: Image.asset('assets/mastercardLogo.png', height: 250),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 40),
        imagePadding: EdgeInsets.only(top: 80),
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      title: "Remit Safely",
      body: "Send money home with competitive exchange rates",
      image: Center(child: Image.asset('assets/remitannce.png', height: 250)),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 40),
        imagePadding: EdgeInsets.only(top: 80),
        pageColor: Colors.white,
      ),
    ),
  ];

  List<PageViewModel> get list => _list;
}
