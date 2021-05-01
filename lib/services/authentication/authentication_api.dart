// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationApi {
  User get currentUser;

  Stream<User> authStateChanges();

  Future<void> logOut();

  Future<User> loginWithGoogle();

  Future<User> loginWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<void> resetCurrentUserPassword(String newPassword);

  Future<void> deleteUserAccount();

  Future<User> loginWithFacebook();
}
