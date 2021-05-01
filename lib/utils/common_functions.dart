// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:nf_kicks/services/authentication/authentication_api.dart';

class CommonFunctions {
  static Future<void> logOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
      await auth.logOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
