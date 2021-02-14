import 'dart:ui';

import 'package:flutter/material.dart';

Stack backgroundStack(Widget main) {
  return Stack(
    children: [
      Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          color: Colors.deepOrangeAccent.withOpacity(0.1),
        ),
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: main,
        ),
      ),
    ],
  );
}
