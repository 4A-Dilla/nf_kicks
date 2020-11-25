import 'package:firebase_auth/firebase_auth.dart';

abstract class Base {
  User get currentUser;

  Stream<User> authStateChanges();

  Future<void> logOut();

  Future<User> logInWithGoogle();

  Future<User> logInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  // Future<User> logInWithFacebook();
}
