import 'package:flutter/material.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  String language = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: inkColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "APPEARANCE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: inkColor,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Dark Mode"),
            subtitle: const Text("Change the application theme"),
            value: darkMode,
            activeThumbColor: brownColor,
            onChanged: (value) {
              setState(() => darkMode = value);
            },
          ),
          const Divider(color: borderColor),
          const SizedBox(height: 16),
          const Text(
            "LANGUAGE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: inkColor,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: language,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            items: const [
              DropdownMenuItem(value: "English", child: Text("English")),
              DropdownMenuItem(value: "Spanish", child: Text("Spanish")),
              DropdownMenuItem(value: "French", child: Text("French")),
              DropdownMenuItem(value: "German", child: Text("German")),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => language = value);
              }
            },
          ),
        ],
      ),
    );
  }
}

// change password 
// remove dark mode
// logout oka moola
// notifications
// following/ followers