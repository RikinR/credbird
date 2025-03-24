import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPageView extends StatelessWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    return Consumer<PagesProvider>(
      builder: (context, pagesProvider, child) {
        return Scaffold(
          body: pagesProvider.pages[pagesProvider.selectedIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              backgroundColor: theme["backgroundColor"],
              selectedItemColor: theme["buttonHighlight"],
              unselectedItemColor: theme["unhighlightedButton"],
              enableFeedback: false,
              currentIndex: pagesProvider.selectedIndex,
              onTap: pagesProvider.onPageTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, size: 30),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_upward_sharp, size: 30),
                  label: 'Send',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_downward_sharp, size: 30),
                  label: 'Receive',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card_sharp, size: 30),
                  label: 'Card',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_sharp, size: 30),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
