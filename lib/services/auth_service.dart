import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Wrapper returned by signInWithGoogle so callers know if this was a new registration
class GoogleSignInResult {
  final UserCredential credential;
  final bool isNewUser;

  GoogleSignInResult({required this.credential, required this.isNewUser});
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Current User ──────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Google Sign-In ────────────────────────────────────────────
  /// Returns null if user cancelled, otherwise [GoogleSignInResult]
  static Future<GoogleSignInResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // additionalUserInfo?.isNewUser tells us if this Google account
      // was seen for the first time in this Firebase project
      final isNew = userCredential.additionalUserInfo?.isNewUser ?? false;

      return GoogleSignInResult(credential: userCredential, isNewUser: isNew);
    } on FirebaseAuthException catch (e) {
      throw _authException(e);
    } catch (e) {
      throw 'Google Sign-In failed. Please try again.';
    }
  }

  // ── Email & Password Register ─────────────────────────────────
  static Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _authException(e);
    }
  }

  // ── Email & Password Login ────────────────────────────────────
  static Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _authException(e);
    }
  }

  // ── Sign Out (full) ───────────────────────────────────────────
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ── Sign Out Google session only ──────────────────────────────
  /// Use this after manually deleting the Firebase user — Firebase session
  /// is already cleared by delete(), we only need to clear Google's cache.
  static Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  // ── Error Helper ──────────────────────────────────────────────
  static String _authException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'ACCOUNT_EXISTS'; // Caught in Register screen
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':
      case 'invalid-credential':
        return 'ACCOUNT_NOT_FOUND'; // Caught in Login screen
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'account-exists-with-different-credential':
        return 'ACCOUNT_EXISTS'; // Caught in Register screen
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
