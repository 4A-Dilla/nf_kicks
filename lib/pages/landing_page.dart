import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:nf_kicks/pages/landing/landing_map.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  static const String id = 'landing_screen';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedItemPosition = 2;

  Future<void> _logOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthenticationApi>(context, listen: false);
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
      body: SafeArea(
        child: Stack(
          children: [
            LandingMap(),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    alignment: Alignment.center,
                    scale: 7,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: SnakeNavigationBar.color(
                snakeViewColor: Colors.deepOrangeAccent,
                unselectedItemColor: Colors.deepOrangeAccent,
                selectedItemColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20),
                elevation: 2.0,
                behaviour: SnakeBarBehaviour.floating,
                snakeShape: SnakeShape.circle,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                currentIndex: _selectedItemPosition,
                onTap: (index) => setState(() => _selectedItemPosition = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
