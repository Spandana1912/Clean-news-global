import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'services/auth_service.dart';

import 'home_page.dart';

import 'settings_controller.dart';

class EmailVerificationPage extends StatefulWidget {
  final SettingsController settingsController;

  const EmailVerificationPage({super.key, required this.settingsController});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _authService = AuthService();

  bool _checking = false;

  bool _sending = false;

  static const Color paper = Color(0xFFE8D9BA);

  static const Color ink = Color(0xFF2C231D);

  static const Color brown = Color(0xFF59463A);

  static const Color border = Color(0xFF806B57);

  static const Color button = Color(0xFF3A2E26);

  Future<void> _checkVerification() async {
    if (_checking) return;
    setState(() => _checking = true);

    try {
      final isVerified = await _authService.refreshEmailVerification();

      if (!mounted) return;

      if (isVerified) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                HomePage(settingsController: widget.settingsController),
          ),
          (route) => false,
        );
      } else {
        _showMessage(
          'Email not verified yet. Please open the verification link first.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage(
        'Verification check failed: ${e.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _sending = true);

    try {
      await _authService.resendVerificationEmail();

      if (!mounted) return;

      _showMessage(
        'If your email is still unverified, a new verification link has been requested.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _backToLogin() async {
    await _authService.logout();

    if (!mounted) return;

    // AuthGate detects sign-out and displays LoginPage.
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: ink));
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: paper,

      appBar: AppBar(
        backgroundColor: paper,

        foregroundColor: ink,

        elevation: 0,

        centerTitle: true,

        title: Text(
          'VERIFY YOUR EMAIL',

          style: GoogleFonts.libreBaskerville(
            fontSize: 14,

            fontWeight: FontWeight.bold,

            letterSpacing: 1.2,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              width: double.infinity,

              constraints: const BoxConstraints(maxWidth: 520),

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFFEFE2C7),

                border: Border.all(color: border, width: 1.2),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Divider(color: ink, thickness: 1.5),

                  const SizedBox(height: 18),

                  Text(
                    'CLEAN NEWS GLOBAL',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.bodoniModa(
                      fontSize: 26,

                      fontWeight: FontWeight.w900,

                      color: ink,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'A NOTE TO OUR NEW READERS',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.cinzel(
                      fontSize: 10,

                      letterSpacing: 1.3,

                      fontWeight: FontWeight.bold,

                      color: brown,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Divider(color: ink, thickness: 1.2),

                  const SizedBox(height: 24),

                  const Icon(
                    Icons.mark_email_read_outlined,

                    size: 58,

                    color: brown,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Confirm your email address',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.libreBaskerville(
                      fontSize: 19,

                      fontWeight: FontWeight.bold,

                      color: ink,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'We sent a verification link to:',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.libreBaskerville(
                      fontSize: 12,

                      color: brown,
                    ),
                  ),

                  const SizedBox(height: 8),

                  SelectableText(
                    email,

                    textAlign: TextAlign.center,

                    style: GoogleFonts.libreBaskerville(
                      fontSize: 13,

                      fontWeight: FontWeight.bold,

                      color: ink,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Open the email and follow its verification link. Then return here and tap “I HAVE VERIFIED”. Check your spam folder if you cannot find the message.',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.libreBaskerville(
                      fontSize: 12,

                      height: 1.7,

                      color: brown,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    height: 48,

                    child: ElevatedButton(
                      onPressed: (_checking || _sending)
                          ? null
                          : _checkVerification,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: button,

                        foregroundColor: paper,

                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),

                      child: _checking
                          ? const SizedBox(
                              width: 20,

                              height: 20,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,

                                color: paper,
                              ),
                            )
                          : Text(
                              'I HAVE VERIFIED',

                              style: GoogleFonts.cinzel(
                                fontSize: 11,

                                fontWeight: FontWeight.bold,

                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      onPressed: (_checking || _sending) ? null : _resendEmail,

                      style: OutlinedButton.styleFrom(
                        foregroundColor: ink,

                        side: const BorderSide(color: border),

                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),

                      child: _sending
                          ? const SizedBox(
                              width: 18,

                              height: 18,

                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'RESEND VERIFICATION EMAIL',

                              style: GoogleFonts.cinzel(
                                fontSize: 10,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: _backToLogin,

                    child: Text(
                      'SIGN OUT / BACK TO LOGIN',

                      style: GoogleFonts.libreBaskerville(
                        fontSize: 10,

                        color: brown,

                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Divider(color: ink, thickness: 1),

                  const SizedBox(height: 8),

                  Text(
                    'READ • DISCOVER • UNDERSTAND',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.cinzel(
                      fontSize: 9,

                      letterSpacing: 1.4,

                      color: brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
