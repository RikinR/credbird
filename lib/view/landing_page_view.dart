// ignore_for_file: deprecated_member_use

import 'package:credbird/viewmodel/pages_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LandingPageView extends StatelessWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeConfig;
    final pagesProvider = Provider.of<PagesProvider>(context);

    return Stack(
      children: [
        pagesProvider.pages[pagesProvider.selectedIndex],
        Positioned(
          left: 32,
          right: 32,
          bottom: 16,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: theme["buttonHighlight"],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 4; i++)
                  _buildNavigationItem(
                    icon:
                        i == 0
                            ? Icons.home_outlined
                            : i == 1
                            ? Icons.send_rounded
                            : i == 2
                            ? Icons.payments_outlined
                            : Icons.credit_card_outlined,
                    label:
                        i == 0
                            ? 'Home'
                            : i == 1
                            ? 'Send'
                            : i == 2
                            ? 'Receive'
                            : 'Card',
                    isSelected: pagesProvider.selectedIndex == i,
                    onTap: () => pagesProvider.onPageTapped(i),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 12,
            vertical: 10,
          ),
          decoration:
              isSelected
                  ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  )
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.1 : 1.0,
                child: Icon(
                      icon,
                      size: 24, // Slightly larger size for Material icons
                      color:
                          isSelected ? const Color(0xFFFFD700) : Colors.white,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: const Duration(milliseconds: 2000),
                      delay: const Duration(milliseconds: 200),
                      color:
                          isSelected ? const Color(0xFFFFD700) : Colors.white54,
                    ),
              ),
              if (isSelected)
                AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: isSelected ? Offset.zero : const Offset(-0.5, 0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1 : 0,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
