import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionHandler {
  static String handleException(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case "invalid-email":
        errorMessage = "Your email address is to be malformed.";
        break;
      case "wrong-password":
        errorMessage = "Your email or password is incorrect.";
        break;
      case "user-not-found":
        errorMessage = "Your email or password is incorrect.";
        break;
      case "user-disabled":
        errorMessage = "User account has been disabled.";
        break;
      case "operation-not-allowed":
        errorMessage = "This operation is not allowed.";
        break;
      case "email-already-in-use":
        errorMessage =
            "The email is currently in use. Please login or reset your password.";
        break;
      case "requires-recent-login":
        errorMessage = "Please attempt to login again.";
        break;
      case "weak-password":
        errorMessage = "Your password is weak, choose a stronger one.";
        break;
      case "too-many-requests":
        errorMessage = "We have blocked all request from this device.";
        break;
      default:
        errorMessage = "Something unexpected happened, try again later.";
    }
    return errorMessage;
  }
}
