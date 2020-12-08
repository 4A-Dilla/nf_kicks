import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/pages/cart/cart_page.dart';
import 'package:nf_kicks/pages/home/home_page.dart';
import 'package:nf_kicks/pages/landing_page.dart';
import 'package:nf_kicks/pages/loading_page.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:nf_kicks/pages/store/store_page.dart';
import 'package:nf_kicks/services/authentication/authentication.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:provider/provider.dart';

import 'models/store.dart';
import 'pages/user_state_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  bool _connectionStatusBool = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        _connectionStatusBool = true;
      });
    } else {
      setState(() {
        _connectionStatusBool = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nf_Kicks',
      initialRoute: Home.id,
      routes: {
        Home.id: (context) => Home(
              connectionStatus: _connectionStatusBool,
              init: _init,
            ),
        LandingPage.id: (context) => LandingPage(),
      },
    );
  }
}
