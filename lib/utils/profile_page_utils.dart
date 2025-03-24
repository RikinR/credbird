import 'package:flutter/material.dart';

Widget buildProfileOption(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
      size: 16,
    ),
    onTap: () {},
  );
}
