import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';
import 'register_page.dart';
import 'services/auth_service.dart';
import 'settings_controller.dart';
import 'app_strings.dart';

class LoginPage extends StatefulWidget {
  final SettingsController settingsController;

  const LoginPage({super.key, required this.settingsController});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> login() async {
    final usernameOrEmail = usernameController.text.trim();
    final password = passwordController.text;

    if (usernameOrEmail.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF30251E),
          content: Text(
            AppStrings.of(context).loginEnterCredentials,
            style: GoogleFonts.libreBaskerville(
              color: const Color(0xFFF3E8D0),
              fontSize: 12,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginWithUsernameOrEmail(
        identifier: usernameOrEmail,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(settingsController: widget.settingsController),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFE8D9BA),

            title: Text(
              AppStrings.of(context).loginFailed,
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3A2E26),
              ),
            ),

            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: GoogleFonts.libreBaskerville(
                color: const Color(0xFF3A2E26),
                fontSize: 13,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppStrings.of(context).okay.toUpperCase(),
                  style: GoogleFonts.libreBaskerville(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4F3A),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================================================
  // LOGIN PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D9BA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),

            child: Column(
              children: [
                // ==================================================
                // NEWSPAPER HEADER
                // ==================================================

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(vertical: 8),

                  child: Column(
                    children: [
                      // TOP METADATA

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            AppStrings.of(context).theDailyEdition,

                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: const Color(0xFF3A2E26),
                            ),
                          ),

                          Text(
                            AppStrings.of(context).volNo,

                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: const Color(0xFF3A2E26),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // TOP LINE
                      Container(height: 1.5, color: const Color(0xFF30251E)),

                      const SizedBox(height: 8),

                      // ==================================================
                      // MAIN NEWSPAPER MASTHEAD
                      // ==================================================
                      Text(
                        AppStrings.of(context).mastheadClean,

                        textAlign: TextAlign.center,

                        style: GoogleFonts.bodoniModa(
                          fontSize: 43,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          height: 0.95,
                          color: const Color(0xFF2C231D),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        AppStrings.of(context).mastheadGlobal,

                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ==================================================
                      // DOUBLE RULE
                      // ==================================================
                      Container(
                        height: 4,

                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Color(0xFF30251E),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ==================================================
                      // NEWSPAPER INFO
                      // ==================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            AppStrings.of(context).est,

                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: const Color(0xFF59463A),
                            ),
                          ),

                          Text(
                            AppStrings.of(context).newsCultureWorld,

                            style: GoogleFonts.cinzel(
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: const Color(0xFF59463A),
                            ),
                          ),

                          Text(
                            AppStrings.of(context).daily,

                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: const Color(0xFF59463A),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Container(height: 1, color: const Color(0xFF30251E)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // EDITORIAL TAGLINE
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFF806B57),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: Text(
                        AppStrings.of(context).welcomeReader,

                        style: GoogleFonts.cinzel(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: const Color(0xFF3A2E26),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFF806B57),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  AppStrings.of(context).dailyWindow,

                  textAlign: TextAlign.center,

                  style: GoogleFonts.libreBaskerville(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF665548),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // LOGIN PAPER
                // ==================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE2C7),

                    border: Border.all(
                      color: const Color(0xFF806B57),
                      width: 1,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x301F1712),
                        blurRadius: 5,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ==================================================
                      // SECTION TITLE
                      // ==================================================

                      Text(
                        AppStrings.of(context).todaysReader,

                        style: GoogleFonts.bodoniModa(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2C231D),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Container(height: 2, color: const Color(0xFF30251E)),

                      const SizedBox(height: 3),

                      Container(height: 1, color: const Color(0xFF806B57)),

                      const SizedBox(height: 20),

                      // ==================================================
                      // USERNAME LABEL
                      // ==================================================
                      Text(
                        AppStrings.of(context).emailId,

                        style: GoogleFonts.cinzel(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 7),

                      // ==================================================
                      // USERNAME FIELD
                      // ==================================================
                      TextField(
                        controller: usernameController,

                        style: GoogleFonts.libreBaskerville(
                          fontSize: 13,
                          color: const Color(0xFF2C231D),
                        ),

                        decoration: InputDecoration(
                          hintText: AppStrings.of(context).enterEmailId,

                          hintStyle: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color: const Color(0xFF806B57),
                          ),

                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF59463A),
                            size: 20,
                          ),

                          filled: true,

                          fillColor: const Color(0xFFE2D2B3),

                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,

                            borderSide: BorderSide(color: Color(0xFF806B57)),
                          ),

                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,

                            borderSide: BorderSide(color: Color(0xFF806B57)),
                          ),

                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,

                            borderSide: BorderSide(
                              color: Color(0xFF30251E),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // PASSWORD LABEL
                      // ==================================================
                      Text(
                        AppStrings.of(context).password,

                        style: GoogleFonts.cinzel(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 7),

                      // ==================================================
                      // PASSWORD FIELD
                      // ==================================================
                      TextField(
                        controller: passwordController,

                        obscureText: hidePassword,

                        onSubmitted: (_) {
                          login();
                        },

                        style: GoogleFonts.libreBaskerville(
                          fontSize: 13,
                          color: const Color(0xFF2C231D),
                        ),

                        decoration: InputDecoration(
                          hintText: AppStrings.of(context).enterPassword,

                          hintStyle: GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color: const Color(0xFF806B57),
                          ),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF59463A),
                            size: 20,
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF59463A),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),

                          filled: true,
                          fillColor: const Color(0xFFE2D2B3),

                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFF806B57)),
                          ),

                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFF806B57)),
                          ),

                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Color(0xFF30251E),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      // ==================================================
                      // LOGIN BUTTON
                      // ==================================================
                      SizedBox(
                        width: double.infinity,

                        height: 52,

                        child: ElevatedButton(
                          onPressed: _isLoading ? null : login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A2E26),

                            foregroundColor: const Color(0xFFF3E8D0),

                            elevation: 2,

                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFF3E8D0),
                                  ),
                                )
                              : Text(
                                  AppStrings.of(context).login,

                                  style: GoogleFonts.cinzel(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // SUBSCRIBE
                      // ==================================================
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,

                          children: [
                            Text(
                              AppStrings.of(context).firstTimeReading,

                              style: GoogleFonts.libreBaskerville(
                                fontSize: 11,
                                color: const Color(0xFF665548),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(
                                      settingsController:
                                          widget.settingsController,
                                    ),
                                  ),
                                );
                              },

                              child: Text(
                                AppStrings.of(context).subscribe,

                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3A2E26),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // FOOTER
                // ==================================================
                Container(height: 1, color: const Color(0xFF806B57)),

                const SizedBox(height: 8),

                Text(
                  AppStrings.of(context).readDiscoverUnderstand,

                  style: GoogleFonts.cinzel(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFF665548),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  AppStrings.of(context).loginTagline,

                  textAlign: TextAlign.center,

                  style: GoogleFonts.libreBaskerville(
                    fontSize: 7,
                    letterSpacing: 0.5,
                    color: const Color(0xFF806B57),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}