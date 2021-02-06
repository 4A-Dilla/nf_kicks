import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:nf_kicks/pages/home/home_page.dart';
import 'package:nf_kicks/pages/landing_page.dart';
import 'package:trust_fall/trust_fall.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  bool _connectionStatusBool = false;
  bool _jailbreakOrRootStatusBool = false;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatusAndCheckJailbreakOrRoot);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await (Connectivity().checkConnectivity());
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatusAndCheckJailbreakOrRoot(result);
  }

  Future<void> _updateConnectionStatusAndCheckJailbreakOrRoot(
      ConnectivityResult result) async {
    bool isTrustFall =
        await TrustFall.isJailBroken && await TrustFall.isRealDevice;
    if (isTrustFall == false) {
      // _jailbreakOrRootStatusBool = false;
      print("Not Jailbroken!");
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        print("Wifi or Mobile is on!");
        try {
          final result = await InternetAddress.lookup('youtube.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            setState(() {
              print("Connected!");
              _connectionStatusBool = true;
            });
          }
        } on SocketException catch (_) {
          setState(() {
            print("Not Connected!");
            _connectionStatusBool = false;
          });
        }
      } else {
        setState(() {
          print("Not wifi or mobile is not on!");
          _connectionStatusBool = false;
        });
      }
    } else {
      setState(() {
        print("Jailbroken!");
        _jailbreakOrRootStatusBool = true;
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
              jailbreakOrRootStatus: _jailbreakOrRootStatusBool,
              init: _init,
            ),
        LandingPage.id: (context) => LandingPage(
              connectionStatus: _connectionStatusBool,
              jailbreakOrRootStatus: _jailbreakOrRootStatusBool,
            ),
      },
    );
  }
}
