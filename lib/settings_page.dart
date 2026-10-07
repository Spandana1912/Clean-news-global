// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'theme.dart';
// import 'settings_controller.dart';

// class SettingsPage extends StatefulWidget {
//   final SettingsController settingsController;

//   const SettingsPage({super.key, required this.settingsController});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _changePassword() async {
//     final passwordController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;

//         final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//         final textColor = isDark ? darkInkColor : inkColor;

//         final accentColor = isDark ? darkBrownColor : brownColor;

//         return AlertDialog(
//           backgroundColor: cardBackgroundColor,
//           title: Text(
//             "CHANGE PASSWORD",
//             style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
//           ),
//           content: TextField(
//             controller: passwordController,
//             obscureText: true,
//             style: TextStyle(color: textColor),
//             decoration: InputDecoration(
//               labelText: "New Password",
//               labelStyle: TextStyle(color: accentColor),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("CANCEL", style: TextStyle(color: accentColor)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final password = passwordController.text.trim();

//                 if (password.isEmpty) {
//                   return;
//                 }

//                 try {
//                   await _auth.currentUser?.updatePassword(password);

//                   if (!context.mounted) return;

//                   Navigator.pop(context);

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: accentColor,
//                       content: Text(
//                         "Password updated successfully.",
//                         style: TextStyle(
//                           color: isDark ? darkPaperColor : paperColor,
//                         ),
//                       ),
//                     ),
//                   );
//                 } catch (e) {
//                   if (!context.mounted) return;

//                   Navigator.pop(context);

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: accentColor,
//                       content: Text(
//                         "Unable to update password.",
//                         style: TextStyle(
//                           color: isDark ? darkPaperColor : paperColor,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Text(
//                 "UPDATE",
//                 style: TextStyle(
//                   color: accentColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     passwordController.dispose();
//   }

//   void _showTextSizeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;

//         final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//         final textColor = isDark ? darkInkColor : inkColor;

//         final accentColor = isDark ? darkBrownColor : brownColor;

//         return AlertDialog(
//           backgroundColor: cardBackgroundColor,
//           title: Text(
//             "TEXT SIZE",
//             style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RadioListTile<double>(
//                 title: Text("Small", style: TextStyle(color: textColor)),
//                 value: 0.9,
//                 groupValue: widget.settingsController.textScale,
//                 activeColor: accentColor,
//                 onChanged: (value) {
//                   if (value == null) return;

//                   widget.settingsController.setTextScale(value);

//                   Navigator.pop(context);
//                 },
//               ),
//               RadioListTile<double>(
//                 title: Text("Normal", style: TextStyle(color: textColor)),
//                 value: 1.0,
//                 groupValue: widget.settingsController.textScale,
//                 activeColor: accentColor,
//                 onChanged: (value) {
//                   if (value == null) return;

//                   widget.settingsController.setTextScale(value);

//                   Navigator.pop(context);
//                 },
//               ),
//               RadioListTile<double>(
//                 title: Text("Large", style: TextStyle(color: textColor)),
//                 value: 1.15,
//                 groupValue: widget.settingsController.textScale,
//                 activeColor: accentColor,
//                 onChanged: (value) {
//                   if (value == null) return;

//                   widget.settingsController.setTextScale(value);

//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;

//         final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//         final textColor = isDark ? darkInkColor : inkColor;

//         final accentColor = isDark ? darkBrownColor : brownColor;

//         return AlertDialog(
//           backgroundColor: cardBackgroundColor,
//           title: Text(
//             "SELECT LANGUAGE",
//             style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _languageOption("English", textColor, accentColor),
//               _languageOption("Tamil", textColor, accentColor),
//               _languageOption("Telugu", textColor, accentColor),
//               _languageOption("Hindi", textColor, accentColor),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _languageOption(String value, Color textColor, Color accentColor) {
//     return RadioListTile<String>(
//       title: Text(value, style: TextStyle(color: textColor)),
//       value: value,
//       groupValue: widget.settingsController.language,
//       activeColor: accentColor,
//       onChanged: (newValue) {
//         if (newValue == null) return;

//         widget.settingsController.setLanguage(newValue);

//         Navigator.pop(context);
//       },
//     );
//   }

//   void _showAbout() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//     final textColor = isDark ? darkInkColor : inkColor;

//     final accentColor = isDark ? darkBrownColor : brownColor;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: cardBackgroundColor,
//           title: Text(
//             "ABOUT US",
//             style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
//           ),
//           content: Text(
//             "The Clean News Global provides a clean and simple way to discover and read news from India and around the world.",
//             style: TextStyle(color: textColor, height: 1.5),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("OKAY", style: TextStyle(color: accentColor)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPrivacyPolicy() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//     final textColor = isDark ? darkInkColor : inkColor;

//     final accentColor = isDark ? darkBrownColor : brownColor;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: cardBackgroundColor,
//           title: Text(
//             "PRIVACY POLICY",
//             style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
//           ),
//           content: SingleChildScrollView(
//             child: Text(
//               "Your account information is used only to provide the features of The Clean News Global. We do not display your private account information publicly.",
//               style: TextStyle(color: textColor, height: 1.5),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("CLOSE", style: TextStyle(color: accentColor)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final backgroundColor = isDark ? darkPaperColor : paperColor;

//     final cardBackgroundColor = isDark ? darkCardColor : cardColor;

//     final textColor = isDark ? darkInkColor : inkColor;

//     final accentColor = isDark ? darkBrownColor : brownColor;

//     final dividerColor = isDark ? darkBorderColor : borderColor;

//     final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;
//     return Theme(
//       data: Theme.of(context).copyWith(
//         textTheme: GoogleFonts.libreBaskervilleTextTheme(
//           Theme.of(context).textTheme,
//         ),
//         primaryTextTheme: GoogleFonts.libreBaskervilleTextTheme(
//           Theme.of(context).primaryTextTheme,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: backgroundColor,

//         appBar: AppBar(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           title: Text(
//             "SETTINGS",
//             style: TextStyle(
//               fontWeight: FontWeight.w900,
//               letterSpacing: 1.5,
//               color: textColor,
//             ),
//           ),
//         ),

//         body: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: cardBackgroundColor,
//                 border: Border.all(color: dividerColor),
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.dark_mode_outlined, color: accentColor),
//                     title: Text(
//                       "Dark Mode",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     subtitle: Text(
//                       widget.settingsController.darkMode
//                           ? "Dark theme enabled"
//                           : "Light theme enabled",
//                       style: TextStyle(color: accentColor),
//                     ),
//                     trailing: Switch(
//                       value: widget.settingsController.darkMode,
//                       activeThumbColor: accentColor,
//                       activeTrackColor: fadedBackgroundColor,
//                       onChanged: (value) {
//                         widget.settingsController.setDarkMode(value);
//                       },
//                     ),
//                   ),

//                   Divider(color: dividerColor),

//                   ListTile(
//                     leading: Icon(Icons.notifications_none, color: accentColor),
//                     title: Text(
//                       "Notifications",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     subtitle: Text(
//                       widget.settingsController.notificationsEnabled
//                           ? "News notifications enabled"
//                           : "News notifications disabled",
//                       style: TextStyle(color: accentColor),
//                     ),
//                     trailing: Switch(
//                       value: widget.settingsController.notificationsEnabled,
//                       activeThumbColor: accentColor,
//                       activeTrackColor: fadedBackgroundColor,
//                       onChanged: (value) {
//                         widget.settingsController.setNotifications(value);
//                       },
//                     ),
//                   ),

//                   Divider(color: dividerColor),

//                   ListTile(
//                     leading: Icon(Icons.text_fields, color: accentColor),
//                     title: Text(
//                       "Text Size",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     subtitle: Text(
//                       "Adjust reading text size",
//                       style: TextStyle(color: accentColor),
//                     ),
//                     trailing: Icon(Icons.chevron_right, color: accentColor),
//                     onTap: _showTextSizeDialog,
//                   ),

//                   Divider(color: dividerColor),

//                   ListTile(
//                     leading: Icon(Icons.language, color: accentColor),
//                     title: Text(
//                       "Language",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     subtitle: Text(
//                       widget.settingsController.language,
//                       style: TextStyle(color: accentColor),
//                     ),
//                     trailing: Icon(Icons.chevron_right, color: accentColor),
//                     onTap: _showLanguageDialog,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: cardBackgroundColor,
//                 border: Border.all(color: dividerColor),
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.lock_outline, color: accentColor),
//                     title: Text(
//                       "Change Password",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     trailing: Icon(Icons.chevron_right, color: accentColor),
//                     onTap: _changePassword,
//                   ),

//                   Divider(color: dividerColor),

//                   ListTile(
//                     leading: Icon(Icons.info_outline, color: accentColor),
//                     title: Text(
//                       "About Us",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     trailing: Icon(Icons.chevron_right, color: accentColor),
//                     onTap: _showAbout,
//                   ),

//                   Divider(color: dividerColor),

//                   ListTile(
//                     leading: Icon(
//                       Icons.privacy_tip_outlined,
//                       color: accentColor,
//                     ),
//                     title: Text(
//                       "Privacy Policy",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     trailing: Icon(Icons.chevron_right, color: accentColor),
//                     onTap: _showPrivacyPolicy,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             Center(
//               child: Text(
//                 "THE CLEAN NEWS GLOBAL",
//                 style: TextStyle(
//                   fontSize: 11,
//                   letterSpacing: 2,
//                   color: accentColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';
import 'settings_controller.dart';
import 'app_strings.dart';

class SettingsPage extends StatefulWidget {
  final SettingsController settingsController;

  const SettingsPage({super.key, required this.settingsController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _changePassword() async {
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        final cardBackgroundColor = isDark ? darkCardColor : cardColor;
        final textColor = isDark ? darkInkColor : inkColor;
        final accentColor = isDark ? darkBrownColor : brownColor;

        final strings = AppStrings(widget.settingsController.language);

        return AlertDialog(
          backgroundColor: cardBackgroundColor,

          title: Text(
            strings.changePassword.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),

          content: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: strings.newPassword,
              labelStyle: TextStyle(color: accentColor),
            ),
          ),

          actions: [
            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                strings.cancel.toUpperCase(),
                style: TextStyle(color: accentColor),
              ),
            ),

            // UPDATE
            TextButton(
              onPressed: () async {
                final password = passwordController.text.trim();

                // Empty password
                if (password.isEmpty) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      backgroundColor: accentColor,
                      content: Text(
                        "Please enter a new password.",
                        style: TextStyle(
                          color: isDark ? darkPaperColor : paperColor,
                        ),
                      ),
                    ),
                  );
                  return;
                }

                final user = _auth.currentUser;

                if (user == null) {
                  return;
                }

                // Check whether the new password is the same
                // as the current password.
                try {
                  final email = user.email;

                  if (email == null) {
                    return;
                  }

                  // Re-authenticate using the entered password.
                  final credential = EmailAuthProvider.credential(
                    email: email,
                    password: password,
                  );

                  await user.reauthenticateWithCredential(credential);

                  // If re-authentication succeeds, the entered password
                  // is the CURRENT password.
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      backgroundColor: accentColor,
                      content: Text(
                        "You cannot use your current password.",
                        style: TextStyle(
                          color: isDark ? darkPaperColor : paperColor,
                        ),
                      ),
                    ),
                  );

                  return;
                } on FirebaseAuthException catch (e) {
                  // Wrong password means it is different from
                  // the current password, so continue.
                  if (e.code != 'wrong-password' &&
                      e.code != 'invalid-credential') {
                    if (!dialogContext.mounted) return;

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        backgroundColor: accentColor,
                        content: Text(
                          "Unable to verify the password.",
                          style: TextStyle(
                            color: isDark ? darkPaperColor : paperColor,
                          ),
                        ),
                      ),
                    );

                    return;
                  }
                }

                try {
                  await user.updatePassword(password);

                  if (!dialogContext.mounted) return;

                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      backgroundColor: accentColor,
                      content: Text(
                        strings.passwordUpdatedSuccessfully,
                        style: TextStyle(
                          color: isDark ? darkPaperColor : paperColor,
                        ),
                      ),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!dialogContext.mounted) return;

                  String message = strings.unableToUpdatePassword;

                  if (e.code == 'requires-recent-login') {
                    message =
                        "Please log in again before changing your password.";
                  }

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      backgroundColor: accentColor,
                      content: Text(
                        message,
                        style: TextStyle(
                          color: isDark ? darkPaperColor : paperColor,
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      backgroundColor: accentColor,
                      content: Text(
                        strings.unableToUpdatePassword,
                        style: TextStyle(
                          color: isDark ? darkPaperColor : paperColor,
                        ),
                      ),
                    ),
                  );
                }
              },

              child: Text(
                strings.update.toUpperCase(),
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    passwordController.dispose();
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final cardBackgroundColor = isDark ? darkCardColor : cardColor;

        final textColor = isDark ? darkInkColor : inkColor;

        final accentColor = isDark ? darkBrownColor : brownColor;

        final strings = AppStrings(widget.settingsController.language);

        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            strings.textSize.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<double>(
                title: Text("Small", style: TextStyle(color: textColor)),
                value: 0.9,
                groupValue: widget.settingsController.textScale,
                activeColor: accentColor,
                onChanged: (value) {
                  if (value == null) return;

                  widget.settingsController.setTextScale(value);

                  Navigator.pop(context);
                },
              ),
              RadioListTile<double>(
                title: Text("Normal", style: TextStyle(color: textColor)),
                value: 1.0,
                groupValue: widget.settingsController.textScale,
                activeColor: accentColor,
                onChanged: (value) {
                  if (value == null) return;

                  widget.settingsController.setTextScale(value);

                  Navigator.pop(context);
                },
              ),
              RadioListTile<double>(
                title: Text("Large", style: TextStyle(color: textColor)),
                value: 1.15,
                groupValue: widget.settingsController.textScale,
                activeColor: accentColor,
                onChanged: (value) {
                  if (value == null) return;

                  widget.settingsController.setTextScale(value);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final cardBackgroundColor = isDark ? darkCardColor : cardColor;

        final textColor = isDark ? darkInkColor : inkColor;

        final accentColor = isDark ? darkBrownColor : brownColor;

        final strings = AppStrings(widget.settingsController.language);

        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            strings.languageText.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption("English", textColor, accentColor),
              _languageOption("Tamil", textColor, accentColor),
              _languageOption("Telugu", textColor, accentColor),
              _languageOption("Hindi", textColor, accentColor),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String value, Color textColor, Color accentColor) {
    return RadioListTile<String>(
      title: Text(value, style: TextStyle(color: textColor)),
      value: value,
      groupValue: widget.settingsController.language,
      activeColor: accentColor,
      onChanged: (newValue) {
        if (newValue == null) return;

        widget.settingsController.setLanguage(newValue);

        Navigator.pop(context);
      },
    );
  }

  void _showAbout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final strings = AppStrings(widget.settingsController.language);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            strings.aboutUs.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: Text(
            "The Clean News Global provides a clean and simple way "
            "to discover and read news from India and around the world.",
            style: TextStyle(color: textColor, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OKAY", style: TextStyle(color: accentColor)),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final strings = AppStrings(widget.settingsController.language);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            strings.privacyPolicy.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: SingleChildScrollView(
            child: Text(
              "Your account information is used only to provide "
              "the features of The Clean News Global. "
              "We do not display your private account information publicly.",
              style: TextStyle(color: textColor, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CLOSE", style: TextStyle(color: accentColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;

    final strings = AppStrings(widget.settingsController.language);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.libreBaskervilleTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.libreBaskervilleTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          title: Text(
            strings.settings.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: [
                  // DARK MODE
                  ListTile(
                    leading: Icon(Icons.dark_mode_outlined, color: accentColor),
                    title: Text(
                      strings.darkMode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      widget.settingsController.darkMode
                          ? "Dark theme enabled"
                          : "Light theme enabled",
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Switch(
                      value: widget.settingsController.darkMode,
                      activeThumbColor: accentColor,
                      activeTrackColor: fadedBackgroundColor,
                      onChanged: (value) {
                        widget.settingsController.setDarkMode(value);
                      },
                    ),
                  ),

                  Divider(color: dividerColor),

                  // NOTIFICATIONS
                  // NOTIFICATIONS
                  ListTile(
                    leading: Icon(Icons.notifications_none, color: accentColor),

                    title: Text(
                      strings.notifications,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    subtitle: Text(
                      widget.settingsController.notificationsEnabled
                          ? strings.newsNotificationsEnabled
                          : strings.newsNotificationsDisabled,
                      style: TextStyle(color: accentColor),
                    ),

                    trailing: Switch(
                      value: widget.settingsController.notificationsEnabled,

                      activeThumbColor: accentColor,
                      activeTrackColor: fadedBackgroundColor,

                      onChanged: (value) {
                        widget.settingsController.setNotifications(value);
                      },
                    ),
                  ),

                  Divider(color: dividerColor),

                  // TEXT SIZE
                  ListTile(
                    leading: Icon(Icons.text_fields, color: accentColor),
                    title: Text(
                      strings.textSize,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      "Adjust reading text size",
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showTextSizeDialog,
                  ),

                  Divider(color: dividerColor),

                  // LANGUAGE
                  ListTile(
                    leading: Icon(Icons.language, color: accentColor),
                    title: Text(
                      strings.languageText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      widget.settingsController.language,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showLanguageDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: [
                  // CHANGE PASSWORD
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: accentColor),
                    title: Text(
                      strings.changePassword,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _changePassword,
                  ),

                  Divider(color: dividerColor),

                  // ABOUT US
                  ListTile(
                    leading: Icon(Icons.info_outline, color: accentColor),
                    title: Text(
                      strings.aboutUs,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showAbout,
                  ),

                  Divider(color: dividerColor),

                  // PRIVACY POLICY
                  ListTile(
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: accentColor,
                    ),
                    title: Text(
                      strings.privacyPolicy,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showPrivacyPolicy,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "THE CLEAN NEWS GLOBAL",
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
