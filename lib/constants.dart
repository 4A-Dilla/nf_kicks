import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

final kLogoError = Column(
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
      child: Text(
        "Check wifi connection, something went wrong (please ensure you do not have a jailbroken device)...",
        style: GoogleFonts.josefinSans(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
);

final kLogoCheckEmail = Column(
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
      child: Text(
        "Check your email and login to continue!",
        style: GoogleFonts.josefinSans(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
);

final kLoadingNoLogo = Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.white,
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
  ),
);
