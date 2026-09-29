import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirestoreService _firestoreService = FirestoreService();

  // ============================================================
  // REGISTER
  // ============================================================

  Future<User?> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception('User account could not be created.');
      }

      await _firestoreService.createUserProfile(
        uid: user.uid,
        username: username.trim(),
        email: email.trim(),
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<User?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    }
  }

  Future<User?> loginWithUsernameOrEmail({
    required String identifier,
    required String password,
  }) async {
    final cleanIdentifier = identifier.trim();

    if (cleanIdentifier.contains('@')) {
      return await loginWithEmailPassword(
        email: cleanIdentifier,
        password: password,
      );
    }

    String? email;
    try {
      email = await _firestoreService.getEmailByUsername(cleanIdentifier);
    } catch (_) {
      email = null;
    }

    if (email != null && email.isNotEmpty) {
      return await loginWithEmailPassword(
        email: email,
        password: password,
      );
    }

    // Fallback: If username wasn't found in Firestore (or lookup failed),
    // try direct email login in case cleanIdentifier is the email without @ or user entered email
    try {
      return await loginWithEmailPassword(
        email: cleanIdentifier,
        password: password,
      );
    } catch (e) {
      if (e.toString().contains('The email address is not valid') ||
          e.toString().contains('No account exists')) {
        throw Exception(
          'No account found with username "$cleanIdentifier". Please enter your registered email.',
        );
      }
      rethrow;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // AUTH STATE
  // ============================================================

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============================================================
  // ERROR HANDLING
  // ============================================================

  String _getAuthErrorMessage(String code) {
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
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'The password is too weak.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Check your internet connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}