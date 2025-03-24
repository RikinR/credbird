import 'package:flutter/material.dart';

Widget buildCardFront() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            "neo",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Text(
            "credit",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            "•••• 8907",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Image.asset("assets/mastercardLogo.png", height: 40),
        ),
      ],
    ),
  );
}

Widget buildCardBack() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[700],
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Center(
      child: Text(
        "Card Details",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}

Widget buildIconButton(IconData icon, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        IconButton(icon: Icon(icon, color: Colors.white), onPressed: () {}),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}

Widget buildWalletButton({
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );
}
