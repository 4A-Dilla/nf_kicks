import 'package:flutter/material.dart';

final PreferredSizeWidget mainAppBar = AppBar(
  title: Image.asset(
    'assets/logo.png',
    scale: 10,
  ),
  actions: <IconButton>[
    IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
  ],
);

final ThemeData mainThemeData = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0,
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    elevation: 20,
    backgroundColor: Colors.white,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData(size: 30),
    unselectedIconTheme: IconThemeData(size: 30),
    selectedLabelStyle: TextStyle(
      fontSize: 18,
    ),
  ),
  primarySwatch: Colors.red,
);
