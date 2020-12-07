import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/pages/loading_page.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:provider/provider.dart';

import 'landing_page.dart';
import 'login_registration/login_registration_page.dart';

class UserStatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationApi>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return LoginAndRegistrationPage();
          }
          return Provider<DatabaseApi>(
            create: (_) => Database(uid: user.uid),
            child: LandingPage(),
          );
        }
        return Loading(
          loadingWidget: kLoadingLogo,
        );
      },
    );
  }
}
