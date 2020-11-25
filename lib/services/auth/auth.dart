import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nf_kicks/services/auth/base.dart';

class Auth implements Base {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User> anonymousSignIn() async {
    final anonymousAccount = await _firebaseAuth.signInAnonymously();
    return anonymousAccount.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<User> logInWithEmailAndPassword(String email, String password) async {
    // TODO: implement logInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<User> logInWithFacebook() async {
    // TODO: implement logInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<User> logInWithGoogle() async {}

  @override
  Future<void> logOut() async {
    // TODO: Make googleSignIn and facebookLogin class variables
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
