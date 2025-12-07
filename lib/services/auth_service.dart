// // import 'package:flutter/foundation.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// //
// // class AuthService extends ChangeNotifier {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final GoogleSignIn _googleSignIn = GoogleSignIn();
// //
// //   User? get currentUser => _auth.currentUser;
// //   Stream<User?> get authStateChanges => _auth.authStateChanges();
// //
// //   // Sign in with Google
// //   Future<UserCredential? > signInWithGoogle() async {
// //     try {
// //       final GoogleSignInAccount? googleUser = await _googleSignIn. signIn();
// //       if (googleUser == null) return null;
// //
// //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
// //       final credential = GoogleAuthProvider.credential(
// //         accessToken: googleAuth.accessToken,
// //         idToken: googleAuth.idToken,
// //       );
// //
// //       return await _auth.signInWithCredential(credential);
// //     } catch (e) {
// //       debugPrint('Google Sign In Error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Sign in with Apple
// //   Future<UserCredential?> signInWithApple() async {
// //     try {
// //       final appleCredential = await SignInWithApple.getAppleIDCredential(
// //         scopes: [
// //           AppleIDAuthorizationScopes.email,
// //           AppleIDAuthorizationScopes. fullName,
// //         ],
// //       );
// //
// //       final oauthCredential = OAuthProvider("apple.com").credential(
// //         idToken: appleCredential. identityToken,
// //         accessToken: appleCredential.authorizationCode,
// //       );
// //
// //       return await _auth.signInWithCredential(oauthCredential);
// //     } catch (e) {
// //       debugPrint('Apple Sign In Error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Sign in with Email
// //   Future<UserCredential> signInWithEmail(String email, String password) async {
// //     try {
// //       return await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //     } catch (e) {
// //       debugPrint('Email Sign In Error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Sign up with Email
// //   Future<UserCredential> signUpWithEmail(String email, String password) async {
// //     try {
// //       return await _auth.createUserWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //     } catch (e) {
// //       debugPrint('Email Sign Up Error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Sign out
// //   Future<void> signOut() async {
// //     await _googleSignIn.signOut();
// //     await _auth.signOut();
// //     notifyListeners();
// //   }
// // }
// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in. dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// class AuthService extends ChangeNotifier {
//   Temporary - will add Firebase later
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   User? get currentUser => _auth. currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   // Placeholder methods for now
//   Future<void> signInWithGoogle() async {
//     debugPrint('Google Sign In - Firebase not configured yet');
//   }
//
//   Future<void> signInWithApple() async {
//     debugPrint('Apple Sign In - Firebase not configured yet');
//   }
//
//   Future<void> signInWithEmail(String email, String password) async {
//     debugPrint('Email Sign In - Firebase not configured yet');
//   }
//
//   Future<void> signUpWithEmail(String email, String password) async {
//     debugPrint('Email Sign Up - Firebase not configured yet');
//   }
//
//   Future<void> signOut() async {
//     debugPrint('Sign Out');
//     notifyListeners();
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign In
  Future<UserCredential? > signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('❌ Error signing in with Google: $e');
      rethrow;
    }
  }

  // Apple Sign In
  Future<UserCredential?> signInWithApple() async {
    try {
      // Generate random nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential. identityToken,
        rawNonce: rawNonce,
      );

      // Sign in with Firebase
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('❌ Error signing in with Apple: $e');
      rethrow;
    }
  }

  // Email Sign In
  Future<UserCredential>signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('❌ Error signing in with email: $e');
      rethrow;
    }
  }

  // Email Sign Up
  Future<UserCredential>signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('❌ Error signing up with email: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
      debugPrint('✅ User signed out successfully');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      rethrow;
    }
  }

  // Helper: Generate random nonce for Apple Sign In
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random. secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  // Helper: SHA256 hash
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}