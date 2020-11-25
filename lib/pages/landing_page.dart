import 'package:flutter/material.dart';
import 'package:nf_kicks/services/auth/base.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  Future<void> _logOut(BuildContext context) async {
    try {
      final auth = Provider.of<Base>(context, listen: false);
      await auth.logOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final logoutDialog = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you to logout',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');
    if (logoutDialog == true) {
      _logOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
