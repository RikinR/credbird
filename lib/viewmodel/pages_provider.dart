import 'package:credbird/view/card_view.dart';
import 'package:credbird/view/home_page_view.dart';
import 'package:credbird/view/profile_page_view.dart';
import 'package:credbird/view/receive_page_view.dart';
import 'package:credbird/view/send_page_view.dart';
import 'package:flutter/widgets.dart';

class PagesProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePageView(),
    SendPageView(),
    ReceivePageView(),
    CardView(),
    ProfilePageView(),
  ];

  void onPageTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  List<Widget> get pages => _pages;
}
