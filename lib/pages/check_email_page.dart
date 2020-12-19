import 'package:flutter/material.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/widgets/background_stack.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CheckEmail extends StatelessWidget {
  Future<void> _logOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
      await auth.logOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logOut(context),
        child: Icon(Icons.login),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: backgroundStack(kLogoCheckEmail),
    );
  }
}
