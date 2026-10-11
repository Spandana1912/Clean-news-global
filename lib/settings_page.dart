import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

import 'settings_controller.dart';

import 'app_strings.dart';
import 'services/auth_service.dart';

class SettingsPage extends StatefulWidget {

  final SettingsController settingsController;

  const SettingsPage({super.key, required this.settingsController});

  @override

  State<SettingsPage> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _changePassword() async {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool hideCurrentPassword = true;
    bool hideNewPassword = true;
    bool hideConfirmPassword = true;
    bool isUpdating = false;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final fieldBackgroundColor = isDark ? darkFadedColor : fadedColor;
    final strings = AppStrings(widget.settingsController.language);

    InputDecoration passwordDecoration({
      required String label,
      required bool hidden,
      required VoidCallback toggleVisibility,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: accentColor),
        filled: true,
        fillColor: fieldBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? darkBorderColor : borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          tooltip: hidden ? 'Show password' : 'Hide password',
          icon: Icon(
            hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: accentColor,
          ),
          onPressed: isUpdating ? null : toggleVisibility,
        ),
      );
    }

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: cardBackgroundColor,
                title: Text(
                  strings.changePassword.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                content: SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: currentPasswordController,
                            obscureText: hideCurrentPassword,
                            style: TextStyle(color: textColor),
                            decoration: passwordDecoration(
                              label: 'Current Password',
                              hidden: hideCurrentPassword,
                              toggleVisibility: () => setDialogState(
                                () => hideCurrentPassword = !hideCurrentPassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your current password.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: hideNewPassword,
                            style: TextStyle(color: textColor),
                            decoration: passwordDecoration(
                              label: strings.newPassword,
                              hidden: hideNewPassword,
                              toggleVisibility: () => setDialogState(
                                () => hideNewPassword = !hideNewPassword,
                              ),
                            ),
                            onChanged: (_) {
                              if (formKey.currentState != null) {
                                formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a new password.';
                              }
                              return AuthService.validatePassword(value);
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Password requirements',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• At least 12 characters\n'
                            '• One uppercase and one lowercase letter\n'
                            '• One number and one special character',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: hideConfirmPassword,
                            style: TextStyle(color: textColor),
                            decoration: passwordDecoration(
                              label: 'Confirm New Password',
                              hidden: hideConfirmPassword,
                              toggleVisibility: () => setDialogState(
                                () => hideConfirmPassword = !hideConfirmPassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm your new password.';
                              }
                              if (value != newPasswordController.text) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isUpdating
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      strings.cancel.toUpperCase(),
                      style: TextStyle(color: accentColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: isDark ? darkPaperColor : paperColor,
                    ),
                    onPressed: isUpdating
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            if (currentPasswordController.text ==
                                newPasswordController.text) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  backgroundColor: accentColor,
                                  content: Text(
                                    'Choose a password different from your current password.',
                                    style: TextStyle(
                                      color: isDark ? darkPaperColor : paperColor,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            setDialogState(() => isUpdating = true);

                            try {
                              // Update the password through the shared AuthService.
                              await AuthService().changePassword(
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              );

                              // Verify the new password against Firebase immediately.
                              // This prevents showing success unless Firebase accepts it.
                              final updatedUser = FirebaseAuth.instance.currentUser;
                              final updatedEmail = updatedUser?.email;
                              if (updatedUser == null || updatedEmail == null) {
                                throw Exception(
                                  'Password update could not be verified. Please sign in again.',
                                );
                              }

                              await updatedUser.reauthenticateWithCredential(
                                EmailAuthProvider.credential(
                                  email: updatedEmail,
                                  password: newPasswordController.text,
                                ),
                              );

                              if (!dialogContext.mounted) return;
                              Navigator.of(dialogContext).pop();

                              if (!mounted) return;
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
                            } catch (e) {
                              if (!dialogContext.mounted) return;
                              final message =
                                  e.toString().replaceFirst('Exception: ', '');
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
                              setDialogState(() => isUpdating = false);
                            }
                          },
                    child: isUpdating
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? darkPaperColor : paperColor,
                            ),
                          )
                        : Text(strings.update.toUpperCase()),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    }
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