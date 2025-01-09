import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Logs in the user with email and password.
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Incorrect password. Please try again.";
      } else {
        return e.message ?? "An unknown error occurred";
      }
    } catch (e) {
      // Handle any other errors
      return "Error: $e";
    }
  }
}
