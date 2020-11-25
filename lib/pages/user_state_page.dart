import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/base.dart';

import 'landing_page.dart';
import 'login_registration/login_registration_page.dart';

class UserStatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Base>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            print("my user: $user");
            return LoginAndRegistrationPage();
          }
          return LandingPage();
        }
        return Scaffold(
          body: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.orangeAccent.withOpacity(0.2),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.deepOrangeAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
