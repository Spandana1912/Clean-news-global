import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/auth_service.dart';
import 'home_page.dart';
import 'settings_controller.dart';

class RegisterPage extends StatefulWidget {
  final SettingsController settingsController;

  const RegisterPage({super.key, required this.settingsController});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // ============================================================
  // VINTAGE NEWSPAPER COLORS
  // SAME COLOR SCHEME AS LOGIN PAGE
  // ============================================================

  static const Color backgroundColor = Color(0xFFE8D9BA);
  static const Color darkBrown = Color(0xFF2C231D);
  static const Color mediumBrown = Color(0xFF59463A);
  static const Color borderBrown = Color(0xFF806B57);
  static const Color buttonBrown = Color(0xFF3A2E26);

  // ============================================================
  // REGISTER USER
  // ============================================================

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.registerWithEmailPassword(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: GoogleFonts.libreBaskerville(fontSize: 12),
          ),
          backgroundColor: darkBrown,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // FIELD DECORATION
  // ============================================================

  InputDecoration _fieldDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle: GoogleFonts.libreBaskerville(fontSize: 11, color: borderBrown),

      prefixIcon: Icon(icon, color: mediumBrown, size: 20),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: const Color(0xFFE2D2B3),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderBrown, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkBrown, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  // ============================================================
  // LABEL STYLE
  // ============================================================

  TextStyle _labelStyle() {
    return GoogleFonts.libreBaskerville(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: mediumBrown,
    );
  }

  // ============================================================
  // DISPOSE CONTROLLERS
  // ============================================================

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: darkBrown,
        elevation: 0,

        title: Text(
          'SUBSCRIBE',
          style: GoogleFonts.libreBaskerville(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: darkBrown,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TOP NEWSPAPER LINE
                // ==================================================

                const Divider(color: darkBrown, thickness: 1.2),

                const SizedBox(height: 18),

                // ==================================================
                // NEWSPAPER NAME
                // ==================================================
                Center(
                  child: Text(
                    'CLEAN NEWS GLOBAL',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: darkBrown,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'EST. 2026  •  INDEPENDENT NEWS',
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      color: mediumBrown,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Divider(color: darkBrown, thickness: 1.2),

                const SizedBox(height: 20),

                // ==================================================
                // MAIN HEADING
                // ==================================================
                Center(
                  child: Text(
                    'Create Your Reader Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Join Clean News Global and stay informed.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 11,
                      color: mediumBrown,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // LARGE LOGIN-STYLE FORM CARD
                // ==================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE2C7),
                    border: Border.all(color: borderBrown, width: 1.2),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================================
                      // CARD TITLE
                      // ============================================

                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: borderBrown),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'READER REGISTRATION',
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: darkBrown,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(height: 1, color: borderBrown),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ============================================
                      // USERNAME
                      // ============================================
                      Text('USERNAME', style: _labelStyle()),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _usernameController,

                        keyboardType: TextInputType.name,

                        style: GoogleFonts.libreBaskerville(
                          fontSize: 11,
                          color: darkBrown,
                        ),

                        decoration: _fieldDecoration(
                          hintText: 'Enter your username',
                          icon: Icons.person_outline,
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a username';
                          }

                          if (value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ============================================
                      // EMAIL
                      // ============================================
                      Text('EMAIL ADDRESS', style: _labelStyle()),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,

                        keyboardType: TextInputType.emailAddress,

                        style: GoogleFonts.libreBaskerville(
                          fontSize: 11,
                          color: darkBrown,
                        ),

                        decoration: _fieldDecoration(
                          hintText: 'Enter your email',
                          icon: Icons.email_outlined,
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ============================================
                      // PASSWORD
                      // ============================================
                      Text('PASSWORD', style: _labelStyle()),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,

                        obscureText: _obscurePassword,

                        onEditingComplete: () {
                          _register();
                        },

                        style: GoogleFonts.libreBaskerville(
                          fontSize: 11,
                          color: darkBrown,
                        ),

                        decoration: _fieldDecoration(
                          hintText: 'Create a password',
                          icon: Icons.lock_outline,

                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: mediumBrown,
                              size: 20,
                            ),

                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // ============================================
                      // CREATE ACCOUNT BUTTON
                      // ============================================
                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonBrown,
                            foregroundColor: const Color(0xFFF3E8D0),
                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          onPressed: _isLoading ? null : _register,

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
                                  'CREATE ACCOUNT',
                                  style: GoogleFonts.libreBaskerville(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: const Color(0xFFF3E8D0),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // BACK TO LOGIN
                // ==================================================
                Center(
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },

                    child: Text(
                      'Already have an account?  Back to Login',
                      textAlign: TextAlign.center,

                      style: GoogleFonts.libreBaskerville(
                        fontSize: 12,
                        color: darkBrown,
                        decoration: TextDecoration.underline,
                        decorationColor: darkBrown,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // BOTTOM NEWSPAPER LINE
                // ==================================================
                const Divider(color: borderBrown, thickness: 1),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'YOUR DAILY SOURCE FOR CLEAN NEWS',
                    textAlign: TextAlign.center,

                    style: GoogleFonts.libreBaskerville(
                      fontSize: 7,
                      letterSpacing: 1,
                      color: mediumBrown,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
