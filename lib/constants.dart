import 'package:flutter/material.dart';

final kLoadingLogo = Column(
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
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
      ),
    ),
  ],
);
