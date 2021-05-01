// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database_api.dart';

class MockAuth extends Mock implements AuthenticationApi {}

class MockDb extends Mock implements DatabaseApi {}

class MockUser extends Mock implements User {
  MockUser();
  factory MockUser.uid(String uid) {
    final user = MockUser();
    when(user.uid).thenReturn(uid);
    return user;
  }
}
