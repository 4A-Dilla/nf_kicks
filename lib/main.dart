// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:trust_fall/trust_fall.dart';

// Project imports:
import 'package:nf_kicks/pages/home/home_page.dart';
import 'package:nf_kicks/pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dot_env.load(fileName: ".env");

  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (isProduction) {
    debugPrint = (String message, {int wrapWidth}) {};
  }

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
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (_) {}

    if (!mounted) {
      return Future.value();
    }

    return _updateConnectionStatusAndCheckJailbreakOrRoot(result);
  }

  Future<void> _updateConnectionStatusAndCheckJailbreakOrRoot(
      ConnectivityResult result) async {
    final bool isRootedOrJailbroken = await TrustFall.isJailBroken;
    if (isRootedOrJailbroken == false) {
      _jailbreakOrRootStatusBool = false;
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        try {
          final result = await InternetAddress.lookup('youtube.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            setState(() {
              _connectionStatusBool = true;
            });
          }
        } on SocketException catch (_) {
          setState(() {
            _connectionStatusBool = false;
          });
        }
      } else {
        setState(() {
          _connectionStatusBool = false;
        });
      }
    } else {
      setState(() {
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
