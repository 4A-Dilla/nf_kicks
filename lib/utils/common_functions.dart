import 'package:flutter/widgets.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:provider/provider.dart';

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
