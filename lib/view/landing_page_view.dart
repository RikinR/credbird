// ignore_for_file: deprecated_member_use

import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                backgroundColor: theme["backgroundColor"],
                selectedItemColor: theme["textColor"],
                unselectedItemColor: theme["unhighlightedButton"],
                type: BottomNavigationBarType.fixed,
                elevation: 10,
                enableFeedback: false,
                currentIndex: pagesProvider.selectedIndex,
                onTap: pagesProvider.onPageTapped,
                items: [
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.house,
                    label: 'Home',
                    isSelected: pagesProvider.selectedIndex == 0,
                    theme: theme,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.paperPlane,
                    label: 'Send',
                    isSelected: pagesProvider.selectedIndex == 1,
                    theme: theme,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.handHoldingDollar,
                    label: 'Receive',
                    isSelected: pagesProvider.selectedIndex == 2,
                    theme: theme,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.creditCard,
                    label: 'Card',
                    isSelected: pagesProvider.selectedIndex == 3,
                    theme: theme,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.user,
                    label: 'Profile',
                    isSelected: pagesProvider.selectedIndex == 4,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Map<String, dynamic> theme,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration:
            isSelected
                ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: theme["buttonGradient"],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme["textColor"]!.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                )
                : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
                  icon,
                  size: 22,
                  color:
                      isSelected ? Colors.white : theme["unhighlightedButton"],
                )
                .animate(onPlay: (controller) => controller.repeat())
                .then(delay: 100.ms)
                .shake(
                  hz: isSelected ? 4 : 0,
                  rotation: isSelected ? 0.05 : 0,
                  duration: 500.ms,
                ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().scaleX(begin: 0, end: 1),
          ],
        ),
      ),
      label: label,
    );
  }
}
