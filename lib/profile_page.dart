import 'package:flutter/material.dart';
import 'theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: inkColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: fadedColor,
            child: Icon(Icons.person, size: 50, color: brownColor),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              "TODAY'S READER",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: inkColor,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.bookmark_outline, color: brownColor),
                  title: Text("Saved Articles"),
                  subtitle: Text("Manage your saved news"),
                ),
                Divider(color: borderColor),
                ListTile(
                  leading: Icon(Icons.language, color: brownColor),
                  title: Text("Language"),
                  subtitle: Text("Manage your reading language"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// add new post
