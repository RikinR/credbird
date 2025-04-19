import 'package:credbird/view/initial_views/card_view.dart';
import 'package:credbird/view/home_page_views/home_page_view.dart';
import 'package:credbird/view/receive_page_view.dart';
import 'package:credbird/view/send_page_views/send_page_view.dart';
import 'package:flutter/material.dart';

class PagesProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePageView(),
    const SendPageView(),
    const ReceivePageView(),
    const CardView(),
  ];

  void onPageTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  List<Widget> get pages => _pages;

  double _bottomBarHeight = 60;
  double get bottomBarHeight => _bottomBarHeight;

  void animateBottomBar(bool isExpanded) {
    _bottomBarHeight = isExpanded ? 80 : 60;
    notifyListeners();
  }
}
