import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nf_kicks/services/authentication/authentication.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../loading_page.dart';
import '../something_went_wrong_page.dart';
import '../user_state_page.dart';

class Home extends StatelessWidget {
  static const String id = 'home_screen';
  final bool connectionStatus;
  final bool jailbreakOrRootStatus;
  final Future<FirebaseApp> init;

  Home(
      {@required this.connectionStatus,
      @required this.jailbreakOrRootStatus,
      @required this.init});

  @override
  Widget build(BuildContext context) {
    return connectionStatus && !jailbreakOrRootStatus
        ? FutureBuilder(
            future: init,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SomethingWentWrong();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Provider<AuthenticationApi>(
                  create: (context) => Authentication(),
                  child: UserStatePage(
                    connectionStatus: connectionStatus,
                    jailbreakOrRootStatus: jailbreakOrRootStatus,
                  ),
                );
              }
              return Loading(
                loadingWidget: kLoadingLogo,
              );
            },
          )
        : SomethingWentWrong();
  }
}
