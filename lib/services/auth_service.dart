
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_service.dart';

class AuthService {
  AuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final FirestoreService _firestoreService = FirestoreService();

  // Current Firebase user
  User? get currentUser => _auth.currentUser;

  // Authentication streams
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Stream<User?> get userChanges => _auth.userChanges();

  // ------------------------------------------------------------
  // PASSWORD VALIDATION
  // ------------------------------------------------------------

  static String? validatePassword(String password) {
    if (password.length < 12) {
      return 'Use at least 12 characters.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Include at least one uppercase letter.';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Include at least one lowercase letter.';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Include at least one number.';
    }

    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return 'Include at least one special character.';
    }

    return null;
  }

  // ------------------------------------------------------------
  // REGISTER
  // ------------------------------------------------------------

  Future<User> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    final passwordProblem = validatePassword(password);

    if (passwordProblem != null) {
      throw Exception(passwordProblem);
    }

    final cleanUsername = username.trim();
    final cleanEmail = email.trim();

    try {
      // 1. Create the Firebase Authentication account.
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception(
          'Firebase created no user account. Please try again.',
        );
      }

      // 2. Request verification immediately.
      // If this fails, the account may already exist.
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        throw Exception(
          'Account created, but Firebase could not request the '
          'verification email. Code: ${e.code}. '
          '${e.message ?? "Please try resending the email."}',
        );
      }

      // 3. Create the user's Firestore profile.
      // If this fails, do not ask the user to register again:
      // the Firebase Authentication account already exists.
      await _firestoreService.createUserProfile(
        uid: user.uid,
        username: cleanUsername,
        email: cleanEmail,
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e.code));
    } on FirebaseException catch (e) {
      throw Exception(
        'Your account may already have been created, but saving '
        'your profile failed. Code: ${e.code}. '
        'Please try signing in or contact support.',
      );
    }
  }

  // ------------------------------------------------------------
  // LOGIN WITH EMAIL AND PASSWORD
  // ------------------------------------------------------------

  Future<User?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e.code));
    }
  }

  // ------------------------------------------------------------
  // LOGIN WITH USERNAME OR EMAIL
  // ------------------------------------------------------------

  Future<User?> loginWithUsernameOrEmail({
    required String identifier,
    required String password,
  }) async {
    final value = identifier.trim();

    if (value.isEmpty) {
      throw Exception('Please enter your email or username.');
    }

    if (password.isEmpty) {
      throw Exception('Please enter your password.');
    }

    // Email login
    if (value.contains('@')) {
      return loginWithEmailPassword(
        email: value,
        password: password,
      );
    }

    // Username login: resolve username to its registered email.
    final email = await _firestoreService.getEmailByUsername(value);

    if (email == null || email.isEmpty) {
      throw Exception(
        'Could not find that username. '
        'Please sign in using your registered email.',
      );
    }

    return loginWithEmailPassword(
      email: email,
      password: password,
    );
  }

  // ------------------------------------------------------------
  // RESEND VERIFICATION EMAIL
  // ------------------------------------------------------------

  Future<void> resendVerificationEmail() async {
    // Refresh the user's latest status from Firebase.
    await _auth.currentUser?.reload();

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'You are not signed in. Please sign in again.',
      );
    }

    if (user.emailVerified) {
      return;
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'Firebase could not send the verification request. '
        'Code: ${e.code}. '
        '${e.message ?? "Please try again later."}',
      );
    }
  }

  // ------------------------------------------------------------
  // CHECK VERIFICATION STATUS
  // ------------------------------------------------------------

 
Future<bool> refreshEmailVerification() async {
  final user = _auth.currentUser;

  if (user == null) return false;

  await user.reload();

  // Get the refreshed Firebase user after reload.
  final refreshedUser = _auth.currentUser;

  return refreshedUser?.emailVerified ?? false;
}


  // ------------------------------------------------------------
  // SEND PASSWORD RESET EMAIL
  // ------------------------------------------------------------

  Future<void> sendPasswordReset(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Please enter your email address.');
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e.code));
    }
  }

  // ------------------------------------------------------------
  // CHANGE PASSWORD
  // ------------------------------------------------------------

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final passwordProblem = validatePassword(newPassword);

    if (passwordProblem != null) {
      throw Exception(passwordProblem);
    }

    final user = _auth.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      throw Exception(
        'Please sign in again before changing your password.',
      );
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e.code));
    }
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ------------------------------------------------------------
  // FRIENDLY FIREBASE AUTHENTICATION ERRORS
  // ------------------------------------------------------------

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account exists with this email.';

      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'The password is too weak.';

      case 'requires-recent-login':
        return 'Please sign in again before performing this action.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Check your internet connection.';

      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';

      case 'invalid-verification-code':
        return 'The verification code is invalid or expired.';

      default:
        return 'Authentication failed. Error code: $code';
    }
  }
}
