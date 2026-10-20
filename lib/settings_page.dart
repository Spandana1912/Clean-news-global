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
  // ==========================================================
  // CHANGE PASSWORD
  // ==========================================================

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
    final s = AppStrings.of(context);

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
          tooltip: hidden ? s.showPassword : s.hidePassword,
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
                  s.changePassword.toUpperCase(),
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
                              label: s.currentPassword,
                              hidden: hideCurrentPassword,
                              toggleVisibility: () => setDialogState(
                                () =>
                                    hideCurrentPassword = !hideCurrentPassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return s.enterCurrentPassword;
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
                              label: s.newPassword,
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
                                return s.enterNewPassword;
                              }
                              return AuthService.validatePassword(value);
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.passwordRequirements,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.passwordRequirementsList,
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
                              label: s.confirmNewPassword,
                              hidden: hideConfirmPassword,
                              toggleVisibility: () => setDialogState(
                                () =>
                                    hideConfirmPassword = !hideConfirmPassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return s.confirmYourNewPassword;
                              }
                              if (value != newPasswordController.text) {
                                return s.passwordsDoNotMatch;
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
                      s.cancel.toUpperCase(),
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
                                    s.samePasswordError,
                                    style: TextStyle(
                                      color: isDark
                                          ? darkPaperColor
                                          : paperColor,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            setDialogState(() => isUpdating = true);

                            try {
                              await AuthService().changePassword(
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              );

                              // Verify the new password against Firebase
                              // before showing success.
                              final updatedUser =
                                  FirebaseAuth.instance.currentUser;
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
                                    s.passwordUpdatedSuccessfully,
                                    style: TextStyle(
                                      color: isDark
                                          ? darkPaperColor
                                          : paperColor,
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!dialogContext.mounted) return;
                              final message = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  backgroundColor: accentColor,
                                  content: Text(
                                    message,
                                    style: TextStyle(
                                      color: isDark
                                          ? darkPaperColor
                                          : paperColor,
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
                        : Text(s.update.toUpperCase()),
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

  // ==========================================================
  // TEXT SIZE
  // ==========================================================

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final cardBackgroundColor = isDark ? darkCardColor : cardColor;
        final textColor = isDark ? darkInkColor : inkColor;
        final accentColor = isDark ? darkBrownColor : brownColor;
        final s = AppStrings.of(dialogContext);

        Widget option(String label, double value) {
          return RadioListTile<double>(
            title: Text(label, style: TextStyle(color: textColor)),
            value: value,
            groupValue: widget.settingsController.textScale,
            activeColor: accentColor,
            onChanged: (newValue) {
              if (newValue == null) return;
              widget.settingsController.setTextScale(newValue);
              Navigator.pop(dialogContext);
            },
          );
        }

        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            s.textSize.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option(s.small, 0.9),
              option(s.normal, 1.0),
              option(s.large, 1.15),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // LANGUAGE
  // ==========================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final cardBackgroundColor = isDark ? darkCardColor : cardColor;
        final textColor = isDark ? darkInkColor : inkColor;
        final accentColor = isDark ? darkBrownColor : brownColor;
        final s = AppStrings.of(dialogContext);

        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            s.selectLanguage.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(dialogContext, 'English', textColor, accentColor),
              _languageOption(dialogContext, 'Tamil', textColor, accentColor),
              _languageOption(dialogContext, 'Telugu', textColor, accentColor),
              _languageOption(dialogContext, 'Hindi', textColor, accentColor),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(
    BuildContext dialogContext,
    String value,
    Color textColor,
    Color accentColor,
  ) {
    return RadioListTile<String>(
      title: Text(
        AppStrings.languageDisplayName(value),
        style: TextStyle(color: textColor),
      ),
      value: value,
      groupValue: widget.settingsController.language,
      activeColor: accentColor,
      onChanged: (newValue) {
        if (newValue == null) return;

        // The whole app (including this page) rebuilds in the new language.
        widget.settingsController.setLanguage(newValue);

        Navigator.pop(dialogContext);
      },
    );
  }

  // ==========================================================
  // ABOUT / PRIVACY
  // ==========================================================

  void _showInfoDialog({
    required String title,
    required String message,
    required String buttonLabel,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            title.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: TextStyle(color: textColor, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                buttonLabel.toUpperCase(),
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;
    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final dividerColor = isDark ? darkBorderColor : borderColor;
    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;

    final s = AppStrings.of(context);

    Widget titleText(String text) => Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
    );

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
            s.settings.toUpperCase(),
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
                    title: titleText(s.darkMode),
                    subtitle: Text(
                      widget.settingsController.darkMode
                          ? s.darkThemeEnabled
                          : s.lightThemeEnabled,
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
                  ListTile(
                    leading: Icon(Icons.notifications_none, color: accentColor),
                    title: titleText(s.notifications),
                    subtitle: Text(
                      widget.settingsController.notificationsEnabled
                          ? s.newsNotificationsEnabled
                          : s.newsNotificationsDisabled,
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
                    title: titleText(s.textSize),
                    subtitle: Text(
                      s.adjustReadingTextSize,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showTextSizeDialog,
                  ),

                  Divider(color: dividerColor),

                  // LANGUAGE
                  ListTile(
                    leading: Icon(Icons.language, color: accentColor),
                    title: titleText(s.languageText),
                    subtitle: Text(
                      AppStrings.languageDisplayName(
                        widget.settingsController.language,
                      ),
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
                    title: titleText(s.changePassword),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _changePassword,
                  ),

                  Divider(color: dividerColor),

                  // ABOUT US
                  ListTile(
                    leading: Icon(Icons.info_outline, color: accentColor),
                    title: titleText(s.aboutUs),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () => _showInfoDialog(
                      title: s.aboutUs,
                      message: s.aboutCleanNewsDescription,
                      buttonLabel: s.okay,
                    ),
                  ),

                  Divider(color: dividerColor),

                  // PRIVACY POLICY
                  ListTile(
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: accentColor,
                    ),
                    title: titleText(s.privacyPolicy),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () => _showInfoDialog(
                      title: s.privacyPolicy,
                      message: s.privacyPolicyDescription,
                      buttonLabel: s.close,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                s.brandName.toUpperCase(),
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
