import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nf_kicks/services/auth/base.dart';

class Auth implements Base {
  final _firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User> logInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User> logInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Login aborted by user');
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await googleSignIn.signOut();
    // final facebookLogin = FacebookLogin();
    // facebookLogin.logOut();
  }

  // @override
  // Future<User> logInWithFacebook() async {
  //   final fb = FacebookLogin();
  //   final response = await fb.logIn(permissions: [
  //     FacebookPermission.publicProfile,
  //     FacebookPermission.email
  //   ]);
  //   switch (response.status) {
  //     case FacebookLoginStatus.Success:
  //       final accessToken = response.accessToken;
  //       final userCredential = await _firebaseAuth.signInWithCredential(
  //         FacebookAuthProvider.credential(accessToken.token),
  //       );
  //       return userCredential.user;
  //     case FacebookLoginStatus.Cancel:
  //       throw FirebaseAuthException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     case FacebookLoginStatus.Error:
  //       throw FirebaseAuthException(
  //         code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //         message: response.error.developerMessage,
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }
}
