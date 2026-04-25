import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Single instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream that tells us whenever login state changes
  // (logged in, logged out) — we'll use this in the router
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current logged-in user (null if not logged in)
  User? get currentUser => _auth.currentUser;

  // ── SIGN UP ──────────────────────────────────────────
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _handleError(e); // returns error message string
    }
  }

  // ── LOGIN ─────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // ── LOGOUT ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── PASSWORD RESET ────────────────────────────────────
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _handleError(e);
    }
  }

  // ── ERROR MESSAGES ────────────────────────────────────
  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
