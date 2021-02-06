import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nf_kicks/models/nfkicksUser.dart';
import 'package:nf_kicks/services/authentication/firebase_auth_exception_handler.dart';
import 'package:nf_kicks/services/database/database.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/text_constants.dart';

import 'authentication_api.dart';

class Authentication implements AuthenticationApi {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _fb = FacebookLogin();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  void createUserDetails(UserCredential userCredential, bool isNormalUser) {
    DatabaseApi _databaseApi = Database(uid: userCredential.user.uid);
    if (isNormalUser) {
      _databaseApi.createUser(
          user: new NfkicksUser(
                  email: userCredential.user.email,
                  image: kDefaultImageUrl,
                  has2FA: false,
                  phoneNumber: kDefaultPhoneNumber,
                  fullName: kDefaultFullName)
              .toMap());
    } else {
      _databaseApi.createUser(
          user: new NfkicksUser(
        email: userCredential.user.email,
        fullName: userCredential.user.displayName,
        image: userCredential.user.photoURL,
        has2FA: false,
        phoneNumber: kDefaultPhoneNumber,
      ).toMap());
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      createUserDetails(userCredential, true);
      return userCredential.user;
    } catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return userCredential.user;
    } catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  @override
  Future<User> loginWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        )
            .then((value) {
          createUserDetails(value, false);
        });
        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Login aborted');
    }
  }

  @override
  Future<User> loginWithFacebook() async {
    final response = await _fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth
            .signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        )
            .then((value) {
          createUserDetails(value, false);
        });
        return userCredential;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _fb.logOut();
  }

  @override
  Future<void> resetCurrentUserPassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser.updatePassword(newPassword);
    } catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  @override
  Future<void> deleteUserAccount() async {
    try {
      await _firebaseAuth.currentUser.delete().whenComplete(() => logOut());
    } catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }
}
