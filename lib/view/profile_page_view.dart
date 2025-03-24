// ignore_for_file: use_build_context_synchronously

import 'package:credbird/utils/profile_page_utils.dart';
import 'package:credbird/view/authentication%20view/login_signup_view.dart';
import 'package:credbird/viewmodel/authentication_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final theme = themeProvider.themeConfig;

    return Scaffold(
      backgroundColor: theme["scaffoldBackground"],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: theme["scaffoldBackground"],
        foregroundColor: theme["textColor"],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Name",
                      style: TextStyle(
                        color: theme["textColor"],
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "user@gmail.com",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            buildProfileOption(Icons.person, "Account Settings"),
            buildProfileOption(Icons.lock, "Security"),
            buildProfileOption(Icons.payment, "Payments"),
            buildProfileOption(Icons.help, "Help Center"),
            buildProfileOption(Icons.info, "About Us"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  await authViewModel.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginSignupView(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
