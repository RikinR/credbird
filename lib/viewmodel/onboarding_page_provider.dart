import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardPageProvider extends ChangeNotifier {
  final List<PageViewModel> _list = [
    PageViewModel(
      decoration: PageDecoration(
        bodyFlex: 2,
        imageFlex: 3,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        pageColor: Colors.black,
      ),
      titleWidget: Center(
        child: Text(
          'Credbird',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      bodyWidget: Center(
        child: Text(
          'Welcome to Credbird!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
    PageViewModel(
      decoration: PageDecoration(
        bodyFlex: 2,
        imageFlex: 3,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        pageColor: Colors.black,
      ),
      titleWidget: Center(
        child: Text(
          'Payments Made Easy!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      bodyWidget: Center(
        child: Text(
          'Easily send or receive payments.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
    PageViewModel(
      decoration: PageDecoration(
        bodyFlex: 2,
        imageFlex: 3,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        pageColor: Colors.black,
      ),
      titleWidget: Center(
        child: Text(
          'Generate a Virtual Card!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      bodyWidget: Center(
        child: Text(
          'No need to carry a physical card anymore.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
    PageViewModel(
      decoration: PageDecoration(
        bodyFlex: 2,
        imageFlex: 3,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        pageColor: Colors.black,
      ),
      titleWidget: Center(
        child: Text(
          'Remit Safely!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      bodyWidget: Center(
        child: Text(
          'Need to send money home? No worries, we got you covered.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  ];

  List<PageViewModel> get list => _list;
}
