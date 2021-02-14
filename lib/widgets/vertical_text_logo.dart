import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/widgets/constants.dart';

Column verticalTextWithLogo({String text}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/logo.png",
      ),
      const SizedBox(
        height: 90,
      ),
      Center(
        child: text != null
            ? Text(
                text,
                style: GoogleFonts.josefinSans(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),
              )
            : const CircularProgressIndicator(
                backgroundColor: kSecondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  kPrimaryColor,
                ),
              ),
      ),
    ],
  );
}
